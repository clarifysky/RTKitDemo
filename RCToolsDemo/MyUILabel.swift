//
//  MyUILabel.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 15/10/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

enum VerticalAlignment: Int {
    case Top = 0
    case Middle = 1
    case Bottom = 2
}

class MyUILabel: UILabel {
    
    var verticalAlignment: VerticalAlignment {
        willSet {
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        self.verticalAlignment = VerticalAlignment.Middle
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var textRect = super.textRectForBounds(bounds, limitedToNumberOfLines: numberOfLines)
        switch self.verticalAlignment {
        case .Top:
            textRect.origin.y = bounds.origin.y
        case .Middle:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2
        case .Bottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height
        }
        return textRect
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let actualRect = self.textRectForBounds(rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawTextInRect(actualRect)
    }

}
