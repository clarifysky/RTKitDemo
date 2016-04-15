//
//  VibrateViewController.swift
//  
//
//  Created by Rex Tsao on 3/9/16.
//
//

import UIKit
import AudioToolbox
import RTKit

class VibrateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        let vibrateButton = UIButton()
        vibrateButton.setTitle("vibrate", forState: .Normal)
        vibrateButton.sizeToFit()
        vibrateButton.addTarget(self, action: #selector(VibrateViewController.vibrate), forControlEvents: .TouchUpInside)
        vibrateButton.frame.origin = CGPointMake(0, 64)
        vibrateButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        print(vibrateButton.frame)
        self.view.addSubview(vibrateButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func vibrate() {
        print("[VibrateViewController:vibrate:] You touched the vibrate button.")
        RTAudio.playVibrate()
    }

}
