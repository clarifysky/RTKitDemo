//
//  RTAudio.swift
//  RTKit
//
//  Created by Rex Tsao on 10/4/2016.
//  Copyright © 2016 rexcao.net. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class RTAudio: NSObject {
    var remoteSoundUrl: String? {
        willSet {
            self.soundData = nil
        }
    }
    var soundFile: String?
    
    private var audioSession: AVAudioSession?
    private lazy var errorPoint: NSErrorPointer? = nil
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    /// current audio playing route.
    private lazy var currentRouteSpeaker = false
    var soundData: NSData?
    var completionHandler: (() -> Void)?
    private var timeStartRecord: Int?
    private var timeStopRecord: Int?
    
    /// Total duration of voice you recorded.
    var recordedDuration: Int? {
        get {
            return self.timeStopRecord! - self.timeStartRecord!
        }
    }
    
    private var audioManager: RTAudioManager?
    
    override init() {
        super.init()
        if self.audioSession == nil {
            self.audioSession = AVAudioSession.sharedInstance()
        }
    }
    
    func startRecording(soundFileName: String) {
        RTPrint.shareInstance().prt("recording started...")
        let path = RTFile.appDirectory(.DocumentDirectory, domainMask: .UserDomainMask)
        self.soundFile = path + "/" + soundFileName
        RTPrint.shareInstance().prt("will save sound data to \(self.soundFile)")
        
        let recordSetting: [String: AnyObject] = [
            AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0
        ]
        do {
            try self.audioSession?.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            self.errorPoint?.memory = error
        }
        
        do {
            try self.audioSession?.setActive(true)
        } catch let error as NSError {
            self.errorPoint?.memory = error
        }
        
        do {
            self.recorder = try AVAudioRecorder(URL: NSURL(fileURLWithPath: self.soundFile!), settings: recordSetting)
        } catch let error as NSError {
            self.errorPoint?.memory = error
            self.recorder = nil
        }
        self.recorder?.prepareToRecord()
        self.recorder?.delegate = self
        self.recorder?.record()
        self.timeStartRecord = RTTime.time()
    }
    
    
    func stopRecording() {
        self.recorder?.stop()
        self.timeStopRecord = RTTime.time()
    }
    
    
    /// Attempt to play remote sound.
    ///
    /// - parameter loadingHandler: Processing before remote sound loaded.
    /// - parameter completionHandler: Processing after sound playing finished.
    func playRemote(loadingHandler: (() -> Void)?) {
        
        // Important: Not all the devices support proximityMonitoring.!!
        // Enable proximity monitoring.
        UIDevice.currentDevice().proximityMonitoringEnabled = true
        // If currentDevice support proximityMonitoring, add observer.
        if UIDevice.currentDevice().proximityMonitoringEnabled == true {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.sensorStateChanged(_:)), name: "UIDeviceProximityStateDidChangeNotification", object: nil)
        }
        
        let loadedHandler = {
            self.playWithSpeakers()
        }
        self.currentRouteSpeaker = true
        self.loadSound(loadingHandler, loadedHandler: loadedHandler)
    }
    
    /// Attempt to play local sound.
    ///
    /// - parameter soundPath: Path of sound file in bundle.
    func playLocal(soundPath: String) {
        RTPrint.shareInstance().prt("preparing to play: \(soundPath)")
        // reset player to preparing for next sound.
        self.player = nil
        // Important: Not all the devices support proximityMonitoring.!!
        // Enable proximity monitoring.
        UIDevice.currentDevice().proximityMonitoringEnabled = true
        // If currentDevice support proximityMonitoring, add observer.
        if UIDevice.currentDevice().proximityMonitoringEnabled == true {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.sensorStateChanged(_:)), name: "UIDeviceProximityStateDidChangeNotification", object: nil)
        }
        
        let fileManager = NSFileManager.defaultManager()
        // check if file exists
        if(!fileManager.fileExistsAtPath(soundPath)) {
            RTPrint.shareInstance().prt("voice file does not exist")
        } else {
            self.soundData = NSData(contentsOfFile: soundPath)
            self.playWithSpeakers()
            self.currentRouteSpeaker = true
        }
    }
    
    /// Play sound use AVPlayer.
    ///
    /// - parameter: type This parameter used to identify the sound is local resource or net resource.
    /// - parameter: path The path for sound resource.
    func play(type: AudioItemType, path: String) {
        if self.audioManager == nil {
            self.audioManager = RTAudioManager()
        }
        self.audioManager?.prepare(type, path: path)
        self.audioManager?.setCompletionHandler(self.completionHandler)
        self.audioManager?.play()
    }
    
    private func loadSound(loadingHandler: (() -> Void)?, loadedHandler: (() -> Void)?) {
        if self.soundData == nil {
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), {
                loadingHandler?()
                let soundData = NSData(contentsOfURL: NSURL(string: self.remoteSoundUrl!)!)
                dispatch_async(dispatch_get_main_queue(), {
                    self.soundData = soundData
                    loadedHandler?()
                })
            })
        } else {
            loadedHandler?()
        }
    }
    
    private func playWithHeadphone() {
        do {
            
            try self.audioSession?.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            self.errorPoint?.memory = error
        }
        
        do {
            try self.audioSession?.overrideOutputAudioPort(AVAudioSessionPortOverride.None)
        } catch let error as NSError {
            self.errorPoint?.memory = error
        }
        
        if self.player == nil {
            do {
                self.player = try AVAudioPlayer(data: self.soundData!)
            } catch let error as NSError {
                self.errorPoint?.memory = error
                self.player = nil
            }
            self.player?.delegate = self
        }
        self.player?.prepareToPlay()
        self.player?.play()
    }
    
    private func playWithSpeakers() {
        do {
            try self.audioSession?.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            self.errorPoint?.memory = error
        }
        do {
            try self.audioSession?.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        } catch let error as NSError {
            self.errorPoint?.memory = error
        }
        
        if self.player == nil {
            do {
                self.player = try AVAudioPlayer(data: self.soundData!)
            } catch let error as NSError {
                self.errorPoint?.memory = error
                self.player = nil
            }
            self.player?.delegate = self
        }
        self.player?.prepareToPlay()
        self.player?.play()
    }
    
    // Process observation.
    func sensorStateChanged(notification: NSNotificationCenter) {
        // device is close to user
        if UIDevice.currentDevice().proximityState == true {
            do {
                try self.audioSession?.setCategory(AVAudioSessionCategoryPlayAndRecord)
            } catch let error as NSError {
                self.errorPoint?.memory = error
            }
            do {
                try self.audioSession?.overrideOutputAudioPort(AVAudioSessionPortOverride.None)
            } catch let error as NSError {
                self.errorPoint?.memory = error
            }
            self.currentRouteSpeaker = false
        } else {
            do {
                try self.audioSession?.setCategory(AVAudioSessionCategoryPlayback)
            } catch let error as NSError {
                self.errorPoint?.memory = error
            }
            do {
                try self.audioSession?.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
            } catch let error as NSError {
                self.errorPoint?.memory = error
            }
            self.currentRouteSpeaker = true
        }
    }
    
    /// Clear cached data
    func clear() {
        self.soundFile = nil
        self.soundData = nil
    }
    
    /// Only vibrate the phone when it has been silenced.
    class func playVibrate() {
        AudioServicesPlaySystemSound(UInt32(kSystemSoundID_Vibrate))
    }
    
    class func playSystemSound(id: UInt32 = 1007) {
        AudioServicesPlaySystemSound(id)
    }
}

extension RTAudio: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        // Close proximityMonitoring when playing finished.
        UIDevice.currentDevice().proximityMonitoringEnabled = false
        self.completionHandler?()
    }
}

extension RTAudio: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        self.completionHandler?()
    }
}