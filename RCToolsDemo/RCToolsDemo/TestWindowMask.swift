//
//  TestWindowMask.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 18/9/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import Foundation
import UIKit


class TestWindowMask: NSObject {
    var windowTools: RTTopWindow?
    var popView: UIView?
    
    override init() {
        self.windowTools = RTWindow.sharedTopWindow()
        super.init()
    }
    
    func createControls() {
        let popViewSize = CGSizeMake(200, 150)
        let popViewOrigin = RTMath.centerOrigin(RTWindow.keyWindow()!.bounds.size, childSize: popViewSize)
        
        self.popView = UIView(frame: CGRectMake(popViewOrigin.x, popViewOrigin.y, popViewSize.width, popViewSize.height))
        self.popView!.backgroundColor = UIColor.whiteColor()
        self.popView!.layer.cornerRadius = 10
        
        let closeButton = UIButton(frame: CGRectMake(5, 5, 100, 20))
        closeButton.setTitle("close", forState: UIControlState.Normal)
        closeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        closeButton.sizeToFit()
        closeButton.addTarget(self, action: #selector(TestWindowMask.revokeMask), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.popView!.addSubview(closeButton)
    }
    
    func showMask() {
//        self.createMask()
//        self.createControls()
    }
    
//    func showMaskForRootView() {
//        self.createMaskForRootView()
//        self.createControls()
//    }
    
//    func addTapGesutreToMask() {
//        // add TapGetsture to maskView
//        let tapPopView = UITapGestureRecognizer(target: self, action: "tapPopView:")
//        self.popView?.addGestureRecognizer(tapPopView)
//    }
    
    func tapMaskView(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .Ended:
            print("tapped the popView ")
        default:break
        }
    }
    
    func revokeMask() {
//        self.windowTools.revokeMask(self.popView)
    }
}