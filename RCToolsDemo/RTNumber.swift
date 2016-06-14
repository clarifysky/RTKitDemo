//
//  RTNumber.swift
//  RTKit
//
//  Created by Rex Tsao on 8/4/2016.
//  Copyright © 2016 rexcao.net. All rights reserved.
//

import Foundation

class RTNumber {
    /// Prefix zero for specific number. Only when the number is less than 10,
    /// will this function prefix zero for it.
    class func prefixZero(number: Int) -> String {
        let res = number < 10 ? "0" + String(number) : String(number)
        return res
    }
    
    class func screenHeight() -> CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    
    class func screenWidth() -> CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    class func statusBarWidth() -> CGFloat {
        return UIApplication.sharedApplication().statusBarFrame.width
    }
    
    class func statusBarHeight() -> CGFloat {
        return UIApplication.sharedApplication().statusBarFrame.height
    }
    
    /// Compute two controlPoint based on startPoint and endPoint. This is usually used for UIBezierPath.
    class func controlPoint(startPoint: CGPoint, endPoint: CGPoint) -> (CGPoint, CGPoint) {
        let xDistance = (endPoint.x-startPoint.x)
        
        // control point 1
        let controlPoint1Y = startPoint.y
        let controlPoint1 = CGPointMake(startPoint.x + xDistance/2, controlPoint1Y)
        
        // control point 2
        let controlPoint2Y = endPoint.y
        let controlPoint2 = CGPointMake(controlPoint1.x, controlPoint2Y)
        
        return (controlPoint1, controlPoint2)
    }
}