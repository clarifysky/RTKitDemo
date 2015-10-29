//
//  ParagraphViewController.swift
//  RCToolsDemo
//
//  Created by Apple on 10/15/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class ParagraphViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.buildVertialLabel()
        self.buildRichLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func buildRichLabel() {
        let richLabel = MyUILabel(frame: CGRectMake(140, 100, 120, 500))
        richLabel.verticalAlignment = VerticalAlignment.Bottom
        richLabel.numberOfLines = 0
        let text = "战火为何而燃，秋叶为何而落？天性不可夺，吾辈心中亦有惑。怒拳为谁握？护国安邦惩奸恶，道法自然除心魔。战无休而惑不息，吾辈何以为战？"
//        let text = "This is my code used to build a non-smoking app."
        
        let ps = NSMutableParagraphStyle()
//        ps.baseWritingDirection = NSWritingDirection.RightToLeft
//        ps.alignment = NSTextAlignment.Left
        ps.lineBreakMode = NSLineBreakMode.ByWordWrapping
        // set line height
//        ps.lineHeightMultiple = 20
//        ps.maximumLineHeight = 20
//        ps.minimumLineHeight = 20
        
        
        let attribs = NSMutableDictionary()
//        attribs[NSParagraphStyleAttributeName] = ps
//        attribs[NSWritingDirectionAttributeName] = NSArray(object: NSNumber(integer: 3))
        attribs[NSVerticalGlyphFormAttributeName] = NSNumber(integer: 1)
        attribs[NSTextLayoutSectionOrientation] = NSNumber(integer: 0)
        let attributedText = NSMutableAttributedString(string: text, attributes: attribs as [NSObject : AnyObject])
        
        richLabel.attributedText = attributedText
        richLabel.layer.borderColor = UIColor.blackColor().CGColor
        richLabel.layer.borderWidth = 1.0
        
        self.view.addSubview(richLabel)
    }
    
    func buildVertialLabel() {
        let verticalLabel = UIVerticalLabel(frame: CGRectMake(10, 100, 120, 500))
        let text = "战火为何而燃，秋叶为何而落？天性不可夺，吾辈心中亦有惑。怒拳为谁握？护国安邦惩奸恶，道法自然除心魔。战无休而惑不息，吾辈何以为战？"
        verticalLabel.text = text
        verticalLabel.font = UIFont.systemFontOfSize(26)
        
        verticalLabel.layer.borderColor = UIColor.blackColor().CGColor
        verticalLabel.layer.borderWidth = 1.0
        
        self.view.addSubview(verticalLabel)
    }
}
