//
//  RTMath.swift
//  RTKit
//
//  Created by Rex Tsao on 9/4/2016.
//  Copyright © 2016 rexcao.net. All rights reserved.
//

import Foundation
import UIKit

class RTMath {
    
    /// Get the value when the child view in the middle of parent view.
    class func centerPos(parentLenght: CGFloat, length: CGFloat) -> CGFloat {
        return (parentLenght - length) / 2
    }
    
    /// Get the origin when the child view int the middle of the parent view.
    class func centerOrigin(parentSize: CGSize, childSize: CGSize) -> CGPoint {
        let x = RTMath.centerPos(parentSize.width, length: childSize.width)
        let y = RTMath.centerPos(parentSize.height, length: childSize.height)
        return CGPointMake(x, y)
    }
    
    /// Get size of child view according to parent view and insets.
    class func sizeIntParent(parentSize: CGSize, insets: UIEdgeInsets) -> CGSize {
        let width = parentSize.width - insets.left - insets.right
        let height = parentSize.height - insets.top - insets.bottom
        return CGSizeMake(width, height)
    }
    
    /// Get point in a circle via the angle you specified.
    class func pointAtCircle(center: CGPoint, angle: CGFloat, radius: CGFloat) -> CGPoint {
        var x: CGFloat, y: CGFloat
        x = radius * CGFloat(cosf(Float(angle))) + center.x
        y = radius * CGFloat(sinf(Float(angle))) + center.y
        return CGPointMake(x, y)
    }
    
    /// Get proper size wich fit specific container.
    class func sizeFitContainer(containerSize: CGSize, contentSize: CGSize) -> CGSize {
        var width = contentSize.width
        var height = contentSize.height
        if width > containerSize.width {
            width = containerSize.width
            height = containerSize.width * (contentSize.height / contentSize.width)
        }
        if height > containerSize.height {
            height = containerSize.height
            width = containerSize.height * (contentSize.width / contentSize.height)
        }
        
        return CGSizeMake(width, height)
    }
}