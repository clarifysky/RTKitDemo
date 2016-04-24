//
//  MaskViewController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 19/9/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit


class MaskViewController: UIViewController {
//    var windowBelong: UIWindow?
    var windowTools: RTWindow?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("-mask view did load")
        self.addTapGesutreToMask()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTapGesutreToMask() {
        // add TapGetsture to maskView
        let tapMaskView = UITapGestureRecognizer(target: self, action: #selector(MaskViewController.tapMaskView(_:)))
        self.view.addGestureRecognizer(tapMaskView)
    }
    
    func tapMaskView(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .Ended:
            print("tapped the maskView ")
        default:break
        }
    }

    @IBAction func closeMaskWindow(sender: UIButton) {
        print("You clicked close button")
        print("Views in mask view: \(self.view.subviews.count)")
        
//        self.windowTools?.revokeMask(sender.superview)
        
        

//        self.windowBelong?.rootViewController = nil
//        self.windowBelong?.windowLevel = UIWindowLevelNormal - 1
//        self.windowBelong = nil
    }
}
