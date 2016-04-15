//
//  AudioViewController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 12/11/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController {

    @IBOutlet weak var queneButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    private let remoteSoundUrl = "http://120.24.165.30/ShadoPanAHero.mp3"
    private var audioSession: AVAudioSession?
    private var errorPoint: NSErrorPointer?
    private var player: AVAudioPlayer?
    // current audio playing route.
    private var currentRouteSpeaker = false
    private var soundData: NSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.audioSession == nil {
            self.errorPoint = nil
            self.audioSession = AVAudioSession.sharedInstance()
            // Only "PlayAndRecord" support Audio Session route override.(according to "http://stackoverflow.com/questions/2662585/how-to-switch-between-speaker-and-headphones-in-iphone-application")
            // Default is speakers.
//            self.audioSession?.setCategory(AVAudioSessionCategoryPlayback, error: self.errorPoint!)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func remotePlay(sender: UIButton) {
        //        let aPlayerItem = AVPlayerItem(URL: NSURL(string: self.remoteSoundUrl)!)
//        let anAudioStreamer = AVPlayer(playerItem: aPlayerItem)
//        anAudioStreamer.play()
//        
//        println("currentTime: \(anAudioStreamer.currentTime())")
//        println("duration: \(anAudioStreamer.currentItem.asset.duration)")
        
    var player: AVAudioPlayer!
        do {
            player = try AVAudioPlayer(contentsOfURL: NSURL(string: self.remoteSoundUrl)!)
        } catch let error as NSError {
            self.errorPoint!.memory = error
            player = nil
        }
        if player != nil {
            print("player is not nil")
            player.play()
        }
    }
    
    /**
     This is only used to play remote-sounds.
     */
    @IBAction func switchRoutes(sender: UIButton) {
        
        // Important: Not all the devices support proximityMonitoring.!!
        // Enable proximity monitoring.
        UIDevice.currentDevice().proximityMonitoringEnabled = true
        // If currentDevice support proximityMonitoring, add observer.
        if UIDevice.currentDevice().proximityMonitoringEnabled == true {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AudioViewController.sensorStateChanged(_:)), name: "UIDeviceProximityStateDidChangeNotification", object: nil)
        }
        
        
        var completionHandler: (() -> Void)?
        // Toggle playing route, if current route is Speakers, change it to Headphone,
        // otherwise, change it to Speakers
        if self.currentRouteSpeaker {
            completionHandler = {
                self.switchButton.setTitle("playing..", forState: .Normal)
                self.playWithHeadphone()
            }
            self.currentRouteSpeaker = false
        } else {
            completionHandler = {
                self.switchButton.setTitle("playing..", forState: .Normal)
                self.playWithSpeakers()
            }
            self.currentRouteSpeaker = true
        }
        self.loadSound(completionHandler)
    }
    
    private func loadSound(completionHandler: (() -> Void)?) {
        if self.soundData == nil {
            self.switchButton.setTitle("requesting...", forState: .Normal)
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0), {
                let soundData = NSData(contentsOfURL: NSURL(string: self.remoteSoundUrl)!)
                dispatch_async(dispatch_get_main_queue(), {
                    self.soundData = soundData
                    completionHandler?()
                })
            })
        } else {
            completionHandler?()
        }
    }
    
    private func playWithHeadphone() {
        do {
            // Only "PlayAndRecord" support Audio Session route override.(according to "http://stackoverflow.com/questions/2662585/how-to-switch-between-speaker-and-headphones-in-iphone-application")
            try self.audioSession?.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            self.errorPoint!.memory = error
        }
        do {
            try self.audioSession?.overrideOutputAudioPort(AVAudioSessionPortOverride.None)
        } catch let error as NSError {
            self.errorPoint!.memory = error
        }
//        self.audioSession?.setActive(true, error: self.errorPoint!)
        if self.player == nil {
            do {
                self.player = try AVAudioPlayer(data: self.soundData!)
            } catch let error as NSError {
                self.errorPoint!.memory = error
                self.player = nil
            }
            self.player?.delegate = self
            self.player?.prepareToPlay()
            self.player?.play()
        }
    }
    
    private func playWithSpeakers() {
        do {
            try self.audioSession?.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            self.errorPoint!.memory = error
        }
        do {
            try self.audioSession?.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        } catch let error as NSError {
            self.errorPoint!.memory = error
        }
//        self.audioSession?.setActive(true, error: self.errorPoint!)
        
        if self.player == nil {
            do {
                self.player = try AVAudioPlayer(data: self.soundData!)
            } catch let error as NSError {
                self.errorPoint!.memory = error
                self.player = nil
            }
            self.player?.delegate = self
            self.player?.prepareToPlay()
            self.player?.play()
        }
    }
    
    // Process observation.
    func sensorStateChanged(notification: NSNotificationCenter) {
        // device is close to user
        if UIDevice.currentDevice().proximityState == true {
            self.showPop("close to user")
            do {
                try self.audioSession?.setCategory(AVAudioSessionCategoryPlayAndRecord)
            } catch let error as NSError {
                self.errorPoint!.memory = error
            }
            do {
                try self.audioSession?.overrideOutputAudioPort(AVAudioSessionPortOverride.None)
            } catch let error as NSError {
                self.errorPoint!.memory = error
            }
            self.currentRouteSpeaker = false
        } else {
            self.showPop("away from user")
            do {
                try self.audioSession?.setCategory(AVAudioSessionCategoryPlayback)
            } catch let error as NSError {
                self.errorPoint!.memory = error
            }
            do {
                try self.audioSession?.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
            } catch let error as NSError {
                self.errorPoint!.memory = error
            }
            self.currentRouteSpeaker = true
        }
    }
}

extension AudioViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        self.switchButton.setTitle("SwitchRoutes", forState: .Normal)
        // Close proximityMonitoring when playing finished.
        UIDevice.currentDevice().proximityMonitoringEnabled = false
    }
}
