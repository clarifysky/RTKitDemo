//
//  RCTools.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 17/9/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import Foundation
import UIKit

class RCTools {
    // computation with math
    class Math {
        
        // compute the x or y of origin depend on the border-length of (parent view and sub view)
        class func xyInParentBorder(#borderLengthOfParentView: CGFloat, borderLengthOfSelf: CGFloat) -> CGFloat {
            return (borderLengthOfParentView - borderLengthOfSelf) / 2
        }
        
        // compute the origin of subview in parentview depend on the size of parentview and subview
        class func originInParentView(#sizeOfParentView: CGSize, sizeOfSelf: CGSize) -> CGPoint {
            let x = self.xyInParentBorder(borderLengthOfParentView: sizeOfParentView.width, borderLengthOfSelf: sizeOfSelf.width)
            let y = self.xyInParentBorder(borderLengthOfParentView: sizeOfParentView.height, borderLengthOfSelf: sizeOfSelf.height)
            return CGPointMake(x, y)
        }
        
        class func sizeInParentByInsets(#sizeOfParentView: CGSize, insetsOfParentView: UIEdgeInsets) -> CGSize {
            let width = sizeOfParentView.width - insetsOfParentView.left - insetsOfParentView.right
            let height = sizeOfParentView.height - insetsOfParentView.top - insetsOfParentView.bottom
            return CGSizeMake(width, height)
        }
    }
    
    // window tools
    class Window {
        
        var currentWindow: UIWindow?
        var maskView: UIView?
        var maskLayer: CALayer?
        var maskColor: UIColor? = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
        // index of maskView/maskLayer
        //        var maskViewIndex: Int?
        //        var maskLayerIndex: Int?
        // mask type, 0 represents view mask, 1 represents layer mask
        var maskType: Int?
        
        init() {
            self.currentWindow = self.keyWindow()
        }
        
        func keyWindow() -> UIWindow? {
            return UIApplication.sharedApplication().keyWindow
        }
        
        func mask() {
            println("views before mask: \(self.currentWindow!.subviews.count)")
            let maskView = UIView(frame: UIScreen.mainScreen().bounds)
            maskView.backgroundColor = self.maskColor
            self.currentWindow!.addSubview(maskView)
            //            self.currentWindow!.insertSubview(maskView, aboveSubview: (self.currentWindow?.subviews[self.currentWindow!.subviews.count - 1] as! UIView))
            self.maskView = maskView
            //            self.maskViewIndex = self.currentWindow!.subviews.count - 1
            self.maskType = 0
            
            println("views after mask: \(self.currentWindow!.subviews.count)")
        }
        
        func maskInteraction() {
            println("layers before mask: \(currentWindow!.layer.sublayers.count)")
            
            let maskLayer = CALayer()
            maskLayer.frame = UIScreen.mainScreen().bounds
            maskLayer.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7).CGColor
            self.currentWindow!.layer.addSublayer(maskLayer)
            self.maskLayer = maskLayer
            //            self.maskLayerIndex = self.currentWindow!.layer.sublayers.count - 1
            self.maskType = 1
            
            println("layers after mask: \(currentWindow!.layer.sublayers.count)")
        }
        
        func revokeMask() {
            println("views before remove: \(self.currentWindow!.subviews.count)")
            println("layers before remove: \(self.currentWindow!.layer.sublayers.count)")
            if self.maskType == 0 {
                //                (self.currentWindow?.subviews[self.maskViewIndex!] as! UIView).removeFromSuperview()
                //                self.maskViewIndex = nil
                self.maskView?.removeFromSuperview()
                println("views after remove: \(self.currentWindow!.subviews.count)")
            } else {
                //                (self.currentWindow?.layer.sublayers[self.maskLayerIndex!] as! CALayer).removeFromSuperlayer()
                //                self.maskLayerIndex = nil
                self.maskLayer?.removeFromSuperlayer()
                println("layers after remove: \(currentWindow!.layer.sublayers.count)")
            }
        }
    }
}