//
//  RCAudio.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 3/9/16.
//  Copyright (c) 2016 rexcao. All rights reserved.
//

import Foundation
import AVFoundation

class RCAudio: NSObject {
    //    private let remoteSoundUrl = "http://120.24.165.30/ShadoPanAHero.mp3"
    var remoteSoundUrl: String? {
        willSet {
            self.soundData = nil
        }
    }
    var soundFile: String?
    
    private var audioSession: AVAudioSession?
    private var errorPoint: NSErrorPointer?
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    // current audio playing route.
    private var currentRouteSpeaker = false
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
    
    override init() {
        super.init()
        if self.audioSession == nil {
            self.errorPoint = NSErrorPointer()
            self.audioSession = AVAudioSession.sharedInstance()
        }
    }
    
    func startRecording(soundFileName: String) {
        println("recording started...")
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        self.soundFile = (paths[0] as! String)+"/"+soundFileName
        println("will save sound data to \(self.soundFile)")
        //        RCTools.File.removeFile(self.soundFile!)
        
        let recordSetting = [
            AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0
        ]
        self.audioSession?.setCategory(AVAudioSessionCategoryPlayAndRecord, error: self.errorPoint!)
        self.audioSession?.setActive(true, error: self.errorPoint!)
        
        self.recorder = AVAudioRecorder(URL: NSURL(fileURLWithPath: self.soundFile!), settings: recordSetting as [NSObject : AnyObject], error: self.errorPoint!)
        self.recorder?.prepareToRecord()
        self.recorder?.delegate = self
        self.recorder?.record()
        self.timeStartRecord = DateProc.timeIntervalSince1970()
    }
    
    
    func stopRecording() {
        self.recorder?.stop()
        self.timeStopRecord = DateProc.timeIntervalSince1970()
    }
    
    
    /// Attempt to play remote sound.
    ///
    /// :param: loadingHandler Processing before remote sound loaded.
    /// :param: completionHandler Processing after sound playing finished.
    func playRemote(loadingHandler: (() -> Void)?) {
        
        // Important: Not all the devices support proximityMonitoring.!!
        // Enable proximity monitoring.
        UIDevice.currentDevice().proximityMonitoringEnabled = true
        // If currentDevice support proximityMonitoring, add observer.
        if UIDevice.currentDevice().proximityMonitoringEnabled == true {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "sensorStateChanged:", name: "UIDeviceProximityStateDidChangeNotification", object: nil)
        }
        
        var loadedHandler = {
            self.playWithSpeakers()
        }
        self.currentRouteSpeaker = true
        self.loadSound(loadingHandler, loadedHandler: loadedHandler)
    }
    
    /// Attempt to play local sound.
    ///
    /// :param: soundPath Path of sound file in bundle.
    func playLocal(soundPath: String) {
        println("preparing to play: \(soundPath)")
        // reset player to preparing for next sound.
        self.player = nil
        // Important: Not all the devices support proximityMonitoring.!!
        // Enable proximity monitoring.
        UIDevice.currentDevice().proximityMonitoringEnabled = true
        // If currentDevice support proximityMonitoring, add observer.
        if UIDevice.currentDevice().proximityMonitoringEnabled == true {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "sensorStateChanged:", name: "UIDeviceProximityStateDidChangeNotification", object: nil)
        }
        
        let fileManager = NSFileManager.defaultManager()
        // check if file exists
        if(!fileManager.fileExistsAtPath(soundPath)) {
            println("voice file does not exist")
        } else {
            self.soundData = NSData(contentsOfFile: soundPath)
            self.playWithSpeakers()
            self.currentRouteSpeaker = true
        }
    }
    
    private func loadSound(loadingHandler: (() -> Void)?, loadedHandler: (() -> Void)?) {
        if self.soundData == nil {
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
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
        // Only "PlayAndRecord" support Audio Session route override.(according to "http://stackoverflow.com/questions/2662585/how-to-switch-between-speaker-and-headphones-in-iphone-application")
        self.audioSession?.setCategory(AVAudioSessionCategoryPlayAndRecord, error: self.errorPoint!)
        self.audioSession?.overrideOutputAudioPort(AVAudioSessionPortOverride.None, error: self.errorPoint!)
        if self.player == nil {
            self.player = AVAudioPlayer(data: self.soundData, error: self.errorPoint!)
            self.player?.delegate = self
        }
        self.player?.prepareToPlay()
        self.player?.play()
    }
    
    private func playWithSpeakers() {
        self.audioSession?.setCategory(AVAudioSessionCategoryPlayback, error: self.errorPoint!)
        self.audioSession?.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: self.errorPoint!)
        
        if self.player == nil {
            self.player = AVAudioPlayer(data: self.soundData, error: self.errorPoint!)
            self.player?.delegate = self
        }
        self.player?.prepareToPlay()
        self.player?.play()
    }
    
    // Process observation.
    func sensorStateChanged(notification: NSNotificationCenter) {
        // device is close to user
        if UIDevice.currentDevice().proximityState == true {
            self.audioSession?.setCategory(AVAudioSessionCategoryPlayAndRecord, error: self.errorPoint!)
            self.audioSession?.overrideOutputAudioPort(AVAudioSessionPortOverride.None, error: self.errorPoint!)
            self.currentRouteSpeaker = false
        } else {
            self.audioSession?.setCategory(AVAudioSessionCategoryPlayback, error: self.errorPoint!)
            self.audioSession?.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: self.errorPoint!)
            self.currentRouteSpeaker = true
        }
    }
    
    /// Clear cached data
    func clear() {
        self.soundFile = nil
        self.soundData = nil
    }
    
    class func playVibrate() {
        println("[RCAudio:playVibrate:]")
        AudioServicesPlaySystemSound(UInt32(kSystemSoundID_Vibrate))
    }
    
    class func playSystemSound(id: UInt32 = 1007) {
        AudioServicesPlaySystemSound(id)
    }
}

extension RCAudio: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        // Close proximityMonitoring when playing finished.
        UIDevice.currentDevice().proximityMonitoringEnabled = false
        self.completionHandler?()
    }
}

extension RCAudio: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        self.completionHandler?()
    }
}
