//
//  CurveShadowView.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 12/10/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

enum CurveShadowAlignment {
    case horizontal
    case vertical
}
class CurveShadowView: UIView {
    
    init(alignment: CurveShadowAlignment, length: CGFloat, anchor: CGPoint) {
        var width: CGFloat = 0, height: CGFloat = 0
        if alignment == CurveShadowAlignment.horizontal {
            width = length
            height = 5
        } else {
            width = 5
            height = length
        }
        let frame = CGRectMake(anchor.x, anchor.y, width, height)
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, frame.height))
//        path.addLineToPoint(CGPointMake(0, 1))
//        path.addQuadCurveToPoint(CGPointMake(frame.width, 1), controlPoint: CGPointMake(frame.width / 2, 5))
//        path.addLineToPoint(CGPointMake(frame.width, 0))
//        path.closePath()
        
        path.addQuadCurveToPoint(CGPointMake(frame.width, frame.height), controlPoint: CGPointMake(frame.width / 2, frame.height + 5))
        
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSizeMake(0, 1)
        self.layer.shadowPath = path.CGPath
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
