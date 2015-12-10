//
//  AudioViewController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 12/11/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit
import AudioToolbox

class AudioViewController: UIViewController {

    private let remoteSoundUrl = "http://www.rexcao.net.img.800cdn.com/test/ShadoPan_A_Hero.mp3"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func remotePlay(sender: UIButton) {
    }
    
}
