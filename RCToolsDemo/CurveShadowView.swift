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

enum CurveShadowDirection {
    case Top
    case Left
    case Bottom
    case Right
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

extension CALayer {
    // Add a curve shadow to specific layer.
    // If you want to show shadow on both left and right side, you could use more than one layer to achieve this goal.
    func RCCurveShadow(alignment: CurveShadowDirection, color: UIColor? = nil, shadowOpacity: Float = 1.0, archHeight: CGFloat = 5) {
        var startPoint: CGPoint,  endPoint: CGPoint, controlPoint: CGPoint, shadowOffset: CGSize
        switch alignment {
        case .Top:
            startPoint = CGPointMake(0, 0)
            endPoint = CGPointMake(self.frame.width, 0)
            controlPoint = CGPointMake(self.frame.width / 2, -archHeight)
            shadowOffset = CGSizeMake(0, -1)
            break
        case .Left:
            startPoint = CGPointMake(0, self.frame.height)
            endPoint = CGPointMake(0, 0)
            controlPoint = CGPointMake(-archHeight, self.frame.height / 2)
            shadowOffset = CGSizeMake(-1, 0)
            break
        case .Bottom:
            startPoint = CGPointMake(0, self.frame.height)
            endPoint = CGPointMake(self.frame.width, self.frame.height)
            controlPoint = CGPointMake(self.frame.width / 2, self.frame.height + archHeight)
            shadowOffset = CGSizeMake(0, 1)
            break
        case .Right:
            startPoint = CGPointMake(self.frame.width, self.frame.height)
            endPoint = CGPointMake(self.frame.width, 0)
            controlPoint = CGPointMake(self.frame.width + archHeight, self.frame.height / 2)
            shadowOffset = CGSizeMake(1, 0)
            break
        }
        
        let path = UIBezierPath()
        path.moveToPoint(startPoint)
        path.addQuadCurveToPoint(endPoint, controlPoint: controlPoint)
        
        shadowOffset = CGSizeMake(0, 0)
        self.shadowOpacity = shadowOpacity
        self.shadowOffset = shadowOffset
        if color != nil {
            self.shadowColor = color!.CGColor
        }
        
        self.shadowPath = path.CGPath
    }
    
    func RCMultiCurveShadow(alignments: [CurveShadowDirection],  color: UIColor? = nil, shadowOpacity: Float = 1.0, archHeight: CGFloat = 5) {
        var points: [[CGPoint]], controlPoints: [CGPoint], shadowOffset: CGSize
    }
}
