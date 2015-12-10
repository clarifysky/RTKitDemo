//
//  RedCircleLayer.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 3/12/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class RedCircleLayer: CALayer {
    
//    var anchorFrame: CGPoint = CGPointZero {
//        willSet {
//            self.frame = CGRect(origin: newValue, size: self.size)
//        }
//    }
    override var frame: CGRect {
        willSet {
            super.frame = newValue
            self.cornerRadius = self.frame.width / 2
        }
    }
    
    override init!() {
        super.init()
        self.backgroundColor = UIColor.redColor().CGColor
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawInContext(ctx: CGContext!) {
        let opath = UIBezierPath(arcCenter: CGPointMake(self.frame.width / 2, self.frame.height / 2), radius: self.frame.width / 2, startAngle: 0, endAngle: 2 * CGFloat(M_PI), clockwise: true)
        UIColor.redColor().setFill()
        opath.fill()
    }
}
