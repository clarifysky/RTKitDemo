//
//  VerticalLUILabel.swift
//  RCToolsDemo
//  Inspired by: 夕阳沉幕 http://blog.sina.com.cn/s/blog_87533a0801016tmj.html
//  Created by Apple on 10/16/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

// From top to bottom, then from right to left to write text.
class UIVerticalLabel: UILabel {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let viewHeight = self.frame.size.height
        let viewWidth = self.frame.size.width
        
        var x: CGFloat, y: CGFloat
        let width = self.font.pointSize + 1
        let height = self.font.pointSize + 1
//        let width = self.attributedText.size().width
//        let height = self.attributedText.size().height
        
        let startX: CGFloat = viewWidth - width
        let startY: CGFloat = 0
        
        var drawStr = self.text!
        
        // Number of charachters in every vertical line.
        let charNumber = Int(floor(Float(viewHeight / height)))
        // Number of lines.(this line is vertical direction)
        let actualLineNumber = Int(floor(Float(viewWidth / width)))
        // Number of lines expected.
        let expectedLineNumber = Int(ceil(Float(drawStr.characters.count / charNumber)))
        
        if expectedLineNumber >= actualLineNumber {
            let startIndex = drawStr.startIndex.advancedBy(0)
            let endIndex = drawStr.startIndex.advancedBy(actualLineNumber * charNumber)
            let range = startIndex..<endIndex
//            drawStr = drawStr.substringToIndex(endIndex)
            drawStr = drawStr.substringWithRange(range)
        }
        
        for i in 0 ..< drawStr.characters.count {
            x = startX - floor(CGFloat(i/charNumber))*width
            y = startY + CGFloat(i%charNumber)*height
            
            let charFrame = CGRectMake(x, y, width, height)
            let range = drawStr.startIndex.advancedBy(i)..<drawStr.startIndex.advancedBy(i+1)
            let str = NSString(string: drawStr.substringWithRange(range))
            
            var attribs: [String: AnyObject] = NSDictionary() as! [String : AnyObject]
            attribs[NSFontAttributeName] = self.font
            str.drawInRect(charFrame, withAttributes: attribs)
        }
    }

}
