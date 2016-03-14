//
//  AudioStreamer.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 3/11/16.
//  Copyright (c) 2016 rexcao. All rights reserved.
//
//  NOT FINISHED
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
import CFNetwork

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
    case StoppingTemporarily
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

class RTAudioStream: NSObject {
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
//    {
//        get {
//            objc_sync_enter(self)
//            return self.state!
//            objc_sync_exit(self)
//        }
//        set {
//        }
//    }
    private var lastState: RTAudioStreamState?
    private var stopReason: RTAudioStreamStopReason?
    private var errorCode: RTAudioStreamErrorCode?
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
    private var fileLength: Int?
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
    
    private let BitRateEstimationMaxPackets = 5000
    private let BitRateEstimationMinPackets = 50
    static let ASStatusChangedNotification = "ASStatusChangedNotification"
    static let ASAudioSessionInterruptionOccuredNotification = "ASAudioSessionInterruptionOccuredNotification"
    
    static let NO_ERROR_STARTING = "No error."
    static let FILE_STREAM_GET_PROPERTY_FAILED_STRING = "File stream get property failed."
    static let FILE_STREAM_SEEK_FAILED_STRING = "File stream seek failed."
    static let FILE_STREAM_PARSE_BYTES_FAILED_STRING = "Parse bytes failed."
    static let FILE_STREAM_OPEN_FAILED_STRING = "Open audio file stream failed."
    static let FILE_STREAM_CLOSE_FAILED_STRING = "Close audio file stream failed."
    static let AUDIO_QUEUE_CREATION_FAILED_STRING = "Audio queue creation failed."
    static let AUDIO_QUEUE_BUFFER_ALLOCATION_FAILED_STRING = "Audio buffer allocation failed."
    static let AUDIO_QUEUE_ENQUEUE_FAILED_STRING = "Queueing of audio buffer failed."
    static let AUDIO_QUEUE_ADD_LISTENER_FAILED_STRING = "Audio queue add listener failed."
    static let AUDIO_QUEUE_REMOVE_LISTENER_FAILED_STRING = "Audio queue remove listener failed."
    static let AUDIO_QUEUE_START_FAILED_STRING = "Audio queue start failed."
    static let AUDIO_QUEUE_BUFFER_MISMATCH_STRING = "Audio queue buffers don't match."
    static let AUDIO_QUEUE_DISPOSE_FAILED_STRING = "Audio queue dispose failed."
    static let AUDIO_QUEUE_PAUSE_FAILED_STRING = "Audio queue pause failed."
    static let AUDIO_QUEUE_STOP_FAILED_STRING = "Audio queue stop failed."
    static let AUDIO_DATA_NOT_FOUND_STRING = "No audio data found."
    static let AUDIO_QUEUE_FLUSH_FAILED_STRING = "Audio queue flush failed."
    static let GET_AUDIO_TIME_FAILED_STRING = "Audio queue get current time failed."
    static let AUDIO_STREAMER_FAILED_STRING = "Audio playback failed"
    static let NETWORK_CONNECTION_FAILED_STRING = "Network connection failed"
    static let AUDIO_BUFFER_TOO_SMALL_STRING = "Audio packets are larger than kAQDefaultBufSize."
    
    
    private func handlePropertyChangeForFileStream(inAudioFileStream: AudioFileStreamID, fileStreamPropertyID inPropertyID: AudioFileStreamPropertyID, ioFlags: UInt32) {
        
    }
    
    private func handleAudioPackets(inInputData: AnyObject?, numberBytes inNumberBytes: UInt32, numberPackets inNumberPackets: UInt32, packetDescriptions inPacketDescriptions: AudioStreamPacketDescription) {
    }
    
    private func handleBufferCompleteForQueue(inAQ: AudioQueueRef, buffer inBuffer: AudioQueueBufferRef) {
        
    }
    
    private func handlePropertyChangeForQueue(inAQ: AudioQueueRef, propertyID inID: AudioQueuePropertyID) {
        
    }
    
    private func handleInterruptionChangeToState(notification: NSNotification) {
        
    }
    
    private func internalSeekToTime(newSeekTime: Double) {
        
    }
    
    private func enqueueBuffer() {
        
    }
    
    private func handleReadFromStream(aStream: CFReadStreamRef, eventType: CFStreamEventType) {
        
    }
}

/// MARK: Audio Callback Function Implementions

/// Receives notification when the AudioFileStream has audio packets to be
/// played. In response, this function creates the AudioQueue, getting it
/// ready to begin playback (playback won't begin until audio packets are
/// sent to the queue in ASEnqueueBuffer).
///
/// This function is adapted from Apple's example in AudioFileStreamExample with
/// kAudioQueueProperty_IsRunning listening added.

func ASPropertyListenerProc(inClientData: AnyObject?, inAudioFileStream: AudioFileStreamID, inPropertyID: AudioFileStreamPropertyID, ioFlags: UInt32) {
    // This is called by audio file stream when it finds property values.
    var streamer = inClientData as! RTAudioStream
    streamer.handlePropertyChangeForFileStream(inAudioFileStream, fileStreamPropertyID: inPropertyID, ioFlags: ioFlags)
}

/// When the AudioStream has packets to be played, this function gets an
/// idle audio buffer and copies the audio packets into it. The calls to
/// ASEnqueueBuffer won't return until there are buffers available (or the
/// playback has been stopped).
///
/// This function is adapted from Apple's example in AudioFileStreamExample with
/// CBR functionality added.
func ASPacketsProc(inClientData: AnyObject?, inNumberBytes: UInt32, inNumberPackets: UInt32, inInputData: AnyObject?, inPacketDescriptions: AudioStreamPacketDescription) {
    // This is called by audio file stream when it finds packets of audio.
    var streamer = inClientData as! RTAudioStream
    streamer.handleAudioPackets(inInputData, numberBytes: inNumberBytes, numberPackets: inNumberPackets, packetDescriptions: inPacketDescriptions)
}

/// Called from the AudioQueue when playback of specific buffers completes. This
/// function signals from the AudioQueue thread to the AudioStream thread that
/// the buffer is idle and available for copying data.
///
/// This function is unchanged from Apple's example in AudioFileStreamExample.
func ASAudioQueueOutputCallback(inClientData: AnyObject?, inAQ: AudioQueueRef, inBuffer: AudioQueueBufferRef) {
    // This is called by the audio queue when it has finished decoding our data.
    // The buffer is now free to be reused.
    var streamer = inClientData as! RTAudioStream
    streamer.handleBufferCompleteForQueue(inAQ, buffer: inBuffer)
}

/// Called from the AudioQueue when playback is started or stopped. This
/// information is used to toggle the observable "isPlaying" property and
/// set the "finished" flag.
func ASAudioQueueIsRunningCallback(inUserData: AnyObject?, inAQ: AudioQueueRef, inID: AudioQueuePropertyID) {
    var streamer = inUserData as! RTAudioStream
    streamer.handlePropertyChangeForQueue(inAQ, propertyID: inID)
}

/// Invoked when the audio session is interrupted (like when the phone rings).
func ASAudioSessionInterruptionListener(inClientData: AnyObject?, inInterruptionState: UInt32) {
    NSNotificationCenter.defaultCenter().postNotificationName(RTAudioStream.ASAudioSessionInterruptionOccuredNotification, object: inInterruptionState as? AnyObject)
}

/// MARK: CFReadStream Callback Function Implementations

/// This is the callback for the CFReadStream from the network connection. This
/// is where all network data is passed to the AudioFileStream.
///
/// Invoked when an error occurs, the stream ends or we have data to read.
func ASReadStreamCallBack(aStream: CFReadStreamRef, eventType: CFStreamEventType, inClientInfo: AnyObject?) {
    var streamer = inClientInfo as! RTAudioStream
    streamer.handleReadFromStream(aStream, eventType: eventType)
}


extension RTAudioStream {
    func initWithURL(aURL: NSURL) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleInterruptionChangeToState:", name: RTAudioStream.ASAudioSessionInterruptionOccuredNotification, object: nil)
    }
    
    /// Returned true if the audio has reached a stopping condition
    func isFinishing() -> Bool {
        objc_sync_enter(self)
        if (errorCode! != .NoError && state! != .Initialized) || ((state! == .Stopping || state! == .Stopped) && stopReason! != .StoppingTemporarily) {
            return true
        }
        objc_sync_exit(self)
        return false
    }
    
    func runLoopShouldExit() -> Bool {
        objc_sync_enter(self)
        if errorCode! != .NoError || (state! == .Stopped && stopReason! != .StoppingTemporarily) {
            return true
        }
        objc_sync_exit(self)
        return false
    }
    
    /// Converts an error code to a string that can be localized or presented
    /// to the user.
    ///
    /// :param: anErrorCode the error code to convert
    /// :return: the string representation of the error code
    func stringForErrorCode(anErrorCode: RTAudioStreamErrorCode) -> String {
        var res = RTAudioStream.AUDIO_STREAMER_FAILED_STRING
        switch anErrorCode {
        case .NoError:
            res = RTAudioStream.NO_ERROR_STARTING
        case .FileStreamGetPropertyFailed:
            res = RTAudioStream.FILE_STREAM_GET_PROPERTY_FAILED_STRING
        case .FileStreamSeekFailed:
            res = RTAudioStream.FILE_STREAM_SEEK_FAILED_STRING
        case .FileStreamParseBytesFailed:
            res = RTAudioStream.FILE_STREAM_PARSE_BYTES_FAILED_STRING
        case .AudioQueueCreationFailed:
            res = RTAudioStream.AUDIO_QUEUE_CREATION_FAILED_STRING
        case .AudioQueueBufferAllocationFailed:
            res = RTAudioStream.AUDIO_QUEUE_BUFFER_ALLOCATION_FAILED_STRING
        case .AudioQueueEnqueueFailed:
            res = RTAudioStream.AUDIO_QUEUE_ENQUEUE_FAILED_STRING
        case .AudioQueueAddListenerFailed:
            res = RTAudioStream.AUDIO_QUEUE_ADD_LISTENER_FAILED_STRING
        case .AudioQueueRemoveListenerFailed:
            res = RTAudioStream.AUDIO_QUEUE_REMOVE_LISTENER_FAILED_STRING
        case .AudioQueueStartFailed:
            res = RTAudioStream.AUDIO_QUEUE_START_FAILED_STRING
        case .AudioQueueBufferMismatch:
            res = RTAudioStream.AUDIO_QUEUE_BUFFER_MISMATCH_STRING
        case .FileStreamOpenFailed:
            res = RTAudioStream.FILE_STREAM_OPEN_FAILED_STRING
        case .FileStreamCloseFailed:
            res = RTAudioStream.FILE_STREAM_CLOSE_FAILED_STRING
        case .AudioQueueDisposeFailed:
            res = RTAudioStream.AUDIO_QUEUE_DISPOSE_FAILED_STRING
        case .AudioQueuePauseFailed:
            res = RTAudioStream.AUDIO_QUEUE_DISPOSE_FAILED_STRING
        case .AudioQueueFlushFailed:
            res = RTAudioStream.AUDIO_QUEUE_FLUSH_FAILED_STRING
        case .AudioDataNotFound:
            res = RTAudioStream.AUDIO_DATA_NOT_FOUND_STRING
        case .GetAudioTimeFailed:
            res = RTAudioStream.GET_AUDIO_TIME_FAILED_STRING
        case .NetworkConnectionFailed:
            res = RTAudioStream.NETWORK_CONNECTION_FAILED_STRING
        case .AudioQueueStopFailed:
            res = RTAudioStream.AUDIO_QUEUE_STOP_FAILED_STRING
        case .AudioStreamFailed:
            res = RTAudioStream.AUDIO_STREAMER_FAILED_STRING
        case .AudioBufferTooSmall:
            res = RTAudioStream.AUDIO_BUFFER_TOO_SMALL_STRING
        default:
            res = RTAudioStream.AUDIO_STREAMER_FAILED_STRING
        }
        return res
    }
    
    
    func presentAlertWithTitle(title: String, message: String) {
        println(title)
        println(message)
    }
    
    /// Sets the playback state to failed and logs the error.
    func failWithErrorCode(anErrorCode: RTAudioStreamErrorCode) {
        objc_sync_enter(self)
        if errorCode! != .NoError {
            // Only set the error once.
            return
        }
        
        errorCode = anErrorCode
        if err != nil {
            println(err)
        } else {
            self.stringForErrorCode(anErrorCode)
        }
        
        if state! == .Playing || state! == .Paused || state! == .Buffering {
            self.state = .Stopping
            stopReason = .StoppingError
            AudioQueueStop(audioQueue!, Boolean(1))
        }
        if self.shouldDisplayAlertOnError! {
            self.presentAlertWithTitle("Errors", message: "Unable to configure network read stream")
        }
        
        objc_sync_exit(self)
    }
    
    /// Method invoked on main thread to send notifications to the main thread's
    /// notification center.
    func mainThreadStateNotification() {
        var notification = NSNotification(name: RTAudioStream.ASStatusChangedNotification, object: self)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    
    /// Sets the state and sends a notification that the state has changed.
    /// :param: anErrorCode The error condition
    func setSate(aStatus: RTAudioStreamState) {
        objc_sync_enter(self)
        if state! != aStatus {
            state = aStatus
            if NSThread.currentThread().isEqual(NSThread.mainThread()) {
                self.mainThreadStateNotification()
            } else {
            }
        }
        objc_sync_exit(self)
    }
    
    /// Returns true if the audio currently playing.
    func isPlaying() -> Bool {
        if state! == .Playing {
            return true
        }
        return false
    }
    
    /// Returns true if the audio currently playing.
    func isPaused() -> Bool {
        if state! == .Paused {
            return true
        }
        return false
    }
    
    /// Returns true if the AudioStreamer is waiting for a state transition of some
    /// kind.
    func isWaiting() -> Bool {
        objc_sync_enter(self)
        if self.isFinishing() || state! == .StartingFileThread || state! == .WaitingForData || state! == .WaitingForQueueToStart || state! == .Buffering {
            return true
        }
        objc_sync_exit(self)
        return false
    }
    
    /// Returns true if the AudioStream is in the .Initialized state (i.e.
    /// isn't doing anything).
    func isIdle() -> Bool {
        if state! == .Initialized {
            return true
        }
        return false
    }
    
    /// Returns true if the AudioStream was stopped due to some errror, handled through failWithCodeError.
    func isAborted() -> Bool {
        if state! == .Stopping && stopReason! == .StoppingError {
            return true
        }
        return false
    }
    
    /// Generates a first guess for the file type based on the file's extension
    /// :param: fileExtension the file extension
    ///
    /// :return: Returns a file type hint that can be passed to the AudioFileStream
    func hintForFileExtension(fileExtension: String) ->AudioFileTypeID {
        var fileTypeHint: Int?
        switch fileExtension {
        case "mp3":
            fileTypeHint = kAudioFileMP3Type
            break
        case "wav":
            fileTypeHint = kAudioFileWAVEType
            break
        case "aifc":
            fileTypeHint = kAudioFileAIFCType
            break
        case "aiff":
            fileTypeHint = kAudioFileAIFFType
            break
        case "m4a":
            fileTypeHint = kAudioFileM4AType
            break
        case "mp4":
            fileTypeHint = kAudioFileMPEG4Type
            break
        case "caf":
            fileTypeHint = kAudioFileCAFType
            break
        case "aac":
            fileTypeHint = kAudioFileAAC_ADTSType
            break
        default:
            fileTypeHint = kAudioFileAAC_ADTSType
            break
        }
        return UInt32(fileTypeHint!)
    }
    
    /// Open the audioFileStream to parse data and the fileHandle as the data
    /// source.
    func openReadStream() {
        objc_sync_enter(self)
        // Create the HTTP GET request.
        var message = CFHTTPMessageCreateRequest(nil, "GET", url!, kCFHTTPVersion1_1)
        
        // If we are creating this request to seek to a location, set the requested byte
        // range in the headers.
        if fileLength! > 0 && seekByteOffset! > 0 {
            
            let tmp = Double(seekByteOffset!)
            let tmp1 = Double(fileLength!)
            /// MARK: Stopped at here
        }
        
        ///
        objc_sync_exit(self)
    }
}

