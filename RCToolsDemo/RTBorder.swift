//
//  RTAttachedBorder.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 29/4/2016.
//  Copyright © 2016 rexcao. All rights reserved.
//

import Foundation

enum AttachedBorder {
    case Top
    case Left
    case Bottom
    case Right
}

class RTBorder {
    var side: AttachedBorder
    var borderWidth: CGFloat
    var borderColor: UIColor
    
    init(side: AttachedBorder, borderWidth: CGFloat, borderColor: UIColor) {
        self.side = side
        self.borderWidth = borderWidth
        self.borderColor = borderColor
    }
}