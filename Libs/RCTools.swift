//
//  RCTools.swift
//  NoSmoking
//
//  Created by Rex Cao on 16/9/15.
//  Copyright (c) 2015 Breadth. All rights reserved.
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
        var maskColor: UIColor? = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
        
        init() {
            self.currentWindow = self.keyWindow()
        }
        
        func keyWindow() -> UIWindow? {
            return UIApplication.sharedApplication().keyWindow
        }
        
        func mask() {
            let maskView = UIView(frame: UIScreen.mainScreen().bounds)
            maskView.backgroundColor = self.maskColor
            self.currentWindow!.insertSubview(maskView, aboveSubview: (self.currentWindow?.subviews[self.currentWindow!.subviews.count - 1] as! UIView))
            self.maskView = maskView
            
            println("views of current window: \(currentWindow!.subviews.count)")
        }
        
        func maskInteraction() {
            let maskLayer = CALayer()
            maskLayer.frame = UIScreen.mainScreen().bounds
            maskLayer.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7).CGColor
            self.currentWindow!.layer.addSublayer(maskLayer)
            
            println("layers of current window: \(currentWindow!.layer.sublayers.count)")
        }
        
        func revokeMask() {
            if self.currentWindow?.subviews.count > 1 {
                (self.currentWindow?.subviews[self.currentWindow!.subviews.count - 1] as! UIView).removeFromSuperview()
                self.maskView = nil
                println("views of current window: \(self.currentWindow!.subviews.count)")
            } else {
                if (self.currentWindow?.subviews[self.currentWindow!.subviews.count - 1] as! UIView).layer.sublayers.count > 1 {
                    ((self.currentWindow?.subviews[self.currentWindow!.subviews.count - 1] as! UIView).layer.sublayers[1] as! CALayer).removeFromSuperlayer()
                    println("layers of current window: \(currentWindow!.layer.sublayers.count)")
                }
            }
        }
    }
}
