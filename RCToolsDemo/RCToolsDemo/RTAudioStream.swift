//
//  AudioStreamer.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 3/11/16.
//  Copyright (c) 2016 rexcao. All rights reserved.
//
//  =====================================================================================================
//  This software was created based on "AudioStreamer" in https://github.com/mattgallagher/AudioStreamer,
//  this is merely the swift version of "AudioStreamer".
//  Creation rights belong to the author of "mattgallagher/AudioStreamer".
//  =====================================================================================================
//
//  Declaration of original author is below:
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//

import Foundation
import AudioToolbox

enum RTAudioStreamState {
    case Initialized
    case StartingFileThread
    case WaitingForData
    case FlushingEOF
    case WaitingForQueueToStart
    case Playing
    case Buffering
    case Stopping
    case Stopped
    case Paused
}

enum RTAudioStreamStopReason {
    case NoStop
    case StoppingEOF
    case StoppingUserAction
    case StoppingError
    case StoppintTemporarily
}

enum RTAudioStreamErrorCode {
    case NoError
    case NetworkConnectionFailed
    case FileStreamGetPropertyFailed
    case FileStreamSetPropertyFailed
    case FileStreamSeekFailed
    case FileStreamParseBytesFailed
    case FileStreamOpenFailed
    case FileStreamCloseFailed
    case AudioDataNotFound
    case AudioQueueCreationFailed
    case AudioQueueBufferAllocationFailed
    case AudioQueueEnqueueFailed
    case AudioQueueAddListenerFailed
    case AudioQueueRemoveListenerFailed
    case AudioQueueStartFailed
    case AudioQueuePauseFailed
    case AudioQueueBufferMismatch
    case AudioQueueDisposeFailed
    case AudioQueueStopFailed
    case AudioQueueFlushFailed
    case AudioStreamFailed
    case GetAudioTimeFailed
    case AudioBufferTooSmall
}

class RTAudioStream {
    let LOG_QUEUED_BUFFERS = 0
    /// Number of audio queue buffers we allocate. Needs to be big enough to keep audio pipeline
    /// busy (non-zero number of queued buffers) but not so big that audio takes too long to begin
    /// (kNumAQBufs * kAQBufSize of data must be loaded before playback will start).
    ///
    /// Set LOG_QUEUED_BUFFERS to 1 to log how many buffers are queued at any time -- if it drops
    /// to zero too often, this value may need to increase. Min 3, typical 8-24.
    let kNumAQBufs =  16
    /// Number of bytes in each audio queue buffer Needs to be big enough to hold a packet of
    /// audio from the audio file. If number is too large, queuing of audio before playback starts
    /// will take too long.
    /// Highly compressed files can use smaller numbers (512 or less). 2048 should hold all
    /// but the largest packets. A buffer size error will occur if this number is too small.
    let kAQDefaultBufSize = 2048
    /// Number of packet descriptions in our array
    let kAQMaxPacketDescs = 512
    
    private var url: NSURL?
    /// Special threading consideration:
    /// The audioQueue property should only ever be accessed inside a
    /// synchronized(self) block and only *after* checking that ![self isFinishing]
    private var audioQueue: AudioQueueRef?
    /// The audio file stream parser.
    private var audioFileStream: AudioFileStreamID?
    /// Description of the audio
    private var asbd: AudioStreamBasicDescription?
    /// The thread where the download and audio file stream parsing occurs.
    private var internalThread: NSThread?
    
    /// Audio queue buffers.
    private var audioQueueBuffer: [AudioQueueBufferRef]?
    /// Packet descriptions for enquening audio
    private var packetDescs: [AudioStreamPacketDescription]?
    /// The index of the audioQueueBuffer that is being filled.
    private var fillBufferIndex: Int?
    private var packetBufferSize: UInt32?
    /// How many bytes have been filled.
    private var bytesFilled: size_t?
    /// How many packets have been read
    private var packetsFilled: size_t?
    /// Flags to indicate that a buffer is still in use.
    private var inUse: [Bool]?
    private var bufferUsed: Int?
    private var httpHeaders: NSDictionary?
    private var fileExtension: String?
    
    private var state: RTAudioStreamState?
    private var lastState: RTAudioStreamState?
    private var stopReason: RTAudioStreamStopReason?
    private var erroCode: RTAudioStreamErrorCode?
    private var err: OSStatus?
    
    /// Flag to indicate middle of the stream.
    private var disContinuous: Bool?
    
    /// A mutex to protect the inUse flags.
    private var queueBuffersMutex: pthread_mutex_t?
    /// A condition variable for handling the inUse flags.
    private var queueBufferReadyCondition: pthread_cond_t?
    
    private var stream: CFReadStreamRef?
    private var notificationCenter: NSNotificationCenter?
    
    /// Bits per second in the file.
    private var bitRate: UInt32?
    /// Offset of the first audio packet in the stream.
    private var dataOffset: Int?
    /// Length of the file in bytes.
    private var fileLenght: Int?
    /// Seek offset within the file in bytes.
    private var seekByteOffset: Int?
    /// Used when the actual number of audio bytes in the file is known (more accurate than assuming the whole file is audio).
    private var audioDataByteCount: UInt64?
    
    /// Number of packets accumulated for bitrate estimation.
    private var processedPacketsCount: UInt64?
    /// Byte size of accumulated estimation packets.
    private var processedPacketsSizeTotal: UInt64?
    
    private var seekTime: Double?
    private var seekWasRequested: Bool?
    private var requestedSeekTime: Double?
    /// Sample rate of the file (used to compare with samples played by the queue for current playback time).
    private var sampleRate: Double?
    /// Sample rate times frames per packet.
    private var packetDuration: Double?
    /// Last calculated progress point
    private var lastProgress: Double?
    
    private var pausedByInterruption: Bool?
    // To control whether the alert is displayed in failWithErrorCode.
    private var shouldDisplayAlertOnError: Bool?
}