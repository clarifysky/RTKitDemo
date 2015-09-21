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
    var windowTools: RCTools.Window
    var popView: UIView?
    
    override init() {
        self.windowTools = RCTools.Window()
        super.init()
    }
    
    func createMask() {
        println("maskView: before mask, view number is: \(self.windowTools.sharedWindow?.rootViewController?.view.subviews.count)")
        self.windowTools.mask()
    }
    
//    func createMaskForRootView() {
//        self.windowTools = RCTools.Window()
//        println("maskView: before mask, view number is: \(self.windowTools.keyWindow()?.subviews.count)")
//        self.windowTools.maskToRootView()
//    }
    
    func createControls() {
        let popViewSize = CGSizeMake(200, 150)
        let popViewOrigin = RCTools.Math.originInParentView(sizeOfParentView: self.windowTools.keyWindow()!.bounds.size, sizeOfSelf: popViewSize)
        
        self.popView = UIView(frame: CGRectMake(popViewOrigin.x, popViewOrigin.y, popViewSize.width, popViewSize.height))
        self.popView!.backgroundColor = UIColor.whiteColor()
        self.popView!.layer.cornerRadius = 10
        
        let closeButton = UIButton(frame: CGRectMake(5, 5, 100, 20))
        closeButton.setTitle("close", forState: UIControlState.Normal)
        closeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        closeButton.sizeToFit()
        closeButton.addTarget(self, action: "revokeMask", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.popView!.addSubview(closeButton)
        self.windowTools.sharedWindow?.rootViewController?.view.addSubview(self.popView!)
//        self.windowTools.maskView?.addSubview(popView)
    }
    
    func showMask() {
        self.createMask()
//        self.createControls()
    }
    
//    func showMaskForRootView() {
//        self.createMaskForRootView()
//        self.createControls()
//    }
    
    func addTapGesutreToMask() {
        // add TapGetsture to maskView
        let tapPopView = UITapGestureRecognizer(target: self, action: "tapPopView:")
        self.popView?.addGestureRecognizer(tapPopView)
    }
    
    func tapMaskView(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .Ended:
            println("tapped the popView ")
        default:break
        }
    }
    
    func revokeMask() {
        self.windowTools.revokeMask(self.popView)
    }
}