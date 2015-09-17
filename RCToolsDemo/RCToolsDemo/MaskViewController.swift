//
//  MaskViewController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 17/9/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class MaskViewController: UIViewController {

    var windowTools: RCTools.Window?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createMask(sender: UIBarButtonItem) {
        
        self.windowTools = RCTools.Window()
        self.windowTools!.mask()
        
        let popViewSize = CGSizeMake(200, 150)
        let popViewOrigin = RCTools.Math.originInParentView(sizeOfParentView: self.windowTools!.currentWindow!.bounds.size, sizeOfSelf: popViewSize)
        
        let popView = UIView(frame: CGRectMake(popViewOrigin.x, popViewOrigin.y, popViewSize.width, popViewSize.height))
        popView.backgroundColor = UIColor.whiteColor()
        popView.layer.cornerRadius = 10
        
        let closeButton = UIButton(frame: CGRectMake(5, 5, 100, 20))
        closeButton.setTitle("close", forState: UIControlState.Normal)
        closeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        closeButton.sizeToFit()
        closeButton.addTarget(self, action: "revokeMask", forControlEvents: UIControlEvents.TouchUpInside)
        
        popView.addSubview(closeButton)
        self.windowTools?.maskView?.addSubview(popView)
    }
    
    func revokeMask() {
        self.windowTools!.revokeMask()
    }

}
