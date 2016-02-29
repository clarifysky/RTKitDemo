//
//  EWCImageMessageCell.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 2/29/16.
//  Copyright (c) 2016 rexcao. All rights reserved.
//

import Foundation

class EWCImageMessageCell: EWCMessageCell {
    var imageViewMessage: UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createImageViewMessage()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var y = self.imageViewAvatar!.frame.origin.y - 3
        if self.message?.ownerType == .Mine {
            var x = self.imageViewAvatar!.frame.origin.x - self.imageViewMessage!.frame.width - 5
            self.imageViewMessage?.frame.origin = CGPointMake(x, y)
            self.imageViewMessageBackground?.frame = CGRectMake(x, y, self.message!.messageSize!.width + 10, self.message!.messageSize!.height + 10)
        } else if self.message?.ownerType == .Other {
            var x = self.imageViewAvatar!.frame.origin.x + self.imageViewAvatar!.frame.width + 5
            self.imageViewMessage?.frame.origin = CGPointMake(x, y)
            self.imageViewMessageBackground?.frame = CGRectMake(x, y, self.message!.messageSize!.width + 10, self.message!.messageSize!.height + 10)
        }
    }
    
    override func setMessage(message: EWCMessage) {
        super.setMessage(message)
        if message.imagePath != nil {
            if count(message.imagePath!) > 0 {
                self.imageViewMessage?.image = message.image
            } else {
                // image from network
            }
            self.imageViewMessage?.frame = CGRectMake(self.imageViewMessage!.frame.origin.x, self.imageViewMessage!.frame.origin.y, message.messageSize!.width + 10, message.messageSize!.height + 10)
        }
        switch self.message!.ownerType! {
        case .Mine:
            self.imageViewMessageBackground!.image = UIImage(named: "message_sender_background_reversed")?.resizableImageWithCapInsets(UIEdgeInsetsMake(28, 20, 15, 20), resizingMode: .Stretch)
            break
        case .Other:
            self.imageViewMessageBackground!.image = UIImage(named: "message_receiver_background_reversed")?.resizableImageWithCapInsets(UIEdgeInsetsMake(28, 20, 15, 20), resizingMode: .Stretch)
            break
        default: break
        }
    }
    
    private func createImageViewMessage() {
        if self.imageViewMessage == nil {
            self.imageViewMessage = UIImageView()
            self.imageViewMessage?.contentMode = UIViewContentMode.ScaleAspectFill
            self.imageViewMessage?.clipsToBounds = true
            self.insertSubview(self.imageViewMessage!, belowSubview: self.imageViewMessageBackground!)
        }
    }
}