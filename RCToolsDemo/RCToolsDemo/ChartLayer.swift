//
//  ChartLayer.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 24/6/2016.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

class ChartLayer: CALayer {
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawInContext(ctx: CGContext) {
        let dot1 = UIBezierPath(arcCenter: CGPointZero, radius: 5, startAngle: 0, endAngle: 2 * π, clockwise: true)
        let dot2 = UIBezierPath(arcCenter: CGPointMake(10, 20), radius: 5, startAngle: 0, endAngle: 2 * π, clockwise: true)
        let dot3 = UIBezierPath(arcCenter: CGPointMake(20, 10), radius: 5, startAngle: 0, endAngle: 2 * π, clockwise: true)
        
        UIColor.redColor().setFill()
        dot1.fill()
        dot2.fill()
        dot3.fill()
    }

}
