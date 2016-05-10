//
//  AudioSingleViewController.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 10/5/2016.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

class AudioSingleViewController: UIViewController {

    private var audioManager: RTAudioManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.attachStart()
        self.attachPause()

        // RTAudioPlayback
        self.audioManager = RTAudioManager()
//        let path = "http://www.bu-chou-la.com/uploadfile/24Vi.mp3"
        let path = "http://www.bu-chou-la.com/uploadfile/UserSpeech/1/04b07b295fd050e56150e877d4359a72aa37564c.wav"
        self.audioManager?.prepare(.Remote, path: path)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func attachStart() {
        let startButton = UIButton()
        startButton.setTitle("start", forState: .Normal)
        startButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        startButton.addTarget(self, action: #selector(AudioSingleViewController.start), forControlEvents: .TouchUpInside)
        startButton.sizeToFit()
        startButton.setOrigin(CGPointMake(10, 64))
        self.view.addSubview(startButton)
    }
    
    private func attachPause() {
        let pauseButton = UIButton()
        pauseButton.setTitle("pause", forState: .Normal)
        pauseButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        pauseButton.addTarget(self, action: #selector(AudioSingleViewController.pause), forControlEvents: .TouchUpInside)
        pauseButton.sizeToFit()
        pauseButton.setOrigin(CGPointMake(100, 64))
        self.view.addSubview(pauseButton)
    }
    
    func start() {
        print("play")
        self.audioManager?.play()
    }
    
    func pause() {
        print("pause")
        self.audioManager?.pause()
    }

}
