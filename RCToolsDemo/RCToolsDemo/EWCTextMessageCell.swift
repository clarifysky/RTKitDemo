//
//  EWCTextMessageCell.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 2/29/16.
//  Copyright (c) 2016 rexcao. All rights reserved.
//

import Foundation

class EWCTextMessageCell: EWCMessageCell {
    var labelMessagetText: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createLabelMessagetText()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createLabelMessagetText() {
        if self.labelMessagetText == nil {
            self.labelMessagetText = UILabel()
            self.labelMessagetText?.font = UIFont.systemFontOfSize(16)
            self.labelMessagetText?.numberOfLines = 0
            self.addSubview(self.labelMessagetText!)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var y = self.imageViewAvatar!.frame.origin.y + 11
        var x = self.imageViewAvatar!.frame.origin.x + (self.message?.ownerType == .Mine ? -self.labelMessagetText!.frame.width - 27 : self.imageViewAvatar!.frame.width + 23)
        self.labelMessagetText?.frame.origin = CGPointMake(x, y)
        
        x -= 18
        y = self.imageViewAvatar!.frame.origin.y - 5
        var h = max(self.labelMessagetText!.frame.height + 30, self.imageViewAvatar!.frame.height + 10)
        self.imageViewMessageBackground?.frame = CGRectMake(x, y, self.labelMessagetText!.frame.width + 40, h)
    }
    
    override func setMessage(message: EWCMessage) {
        super.setMessage(message)
        self.labelMessagetText?.attributedText = message.attrText
        self.labelMessagetText?.frame = CGRectMake(self.labelMessagetText!.frame.origin.x, self.labelMessagetText!.frame.origin.y, message.messageSize!.width, message.messageSize!.height)
    }
}