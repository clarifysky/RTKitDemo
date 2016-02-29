//
//  EWCMessageCell.swift
//  
//
//  Created by Rex Tsao on 2/26/16.
//
//

import UIKit

class EWCMessageCell: UITableViewCell {
    
    var message: EWCMessage?
    var imageViewAvatar: UIImageView?
    var imageViewMessageBackground: UIImageView?
    var imageViewMessageSendStatus: UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        self.backgroundColor = UIColor.clearColor()
        self.createImageViewAvatar()
        self.createImageViewMessageBackground()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.message?.ownerType == MessageOwnerType.Mine {
            self.imageViewAvatar?.frame.origin = CGPointMake(self.frame.width - 10 - self.imageViewAvatar!.frame.width, 10)
        } else if self.message?.ownerType == MessageOwnerType.Other {
            self.imageViewAvatar?.frame.origin = CGPointMake(10, 10)
        }
    }
    
    
    func setMessage(message: EWCMessage) {
        self.message = message
        switch message.ownerType! {
        case .Mine:
            self.imageViewAvatar?.hidden = false
            self.imageViewAvatar?.image = UIImage(named: message.from!.avatarURL)
            self.imageViewMessageBackground?.hidden = false
            self.imageViewMessageBackground?.image = UIImage(named: "message_sender_background_normal")?.resizableImageWithCapInsets(UIEdgeInsetsMake(28, 20, 15, 20), resizingMode: UIImageResizingMode.Stretch)
            self.imageViewMessageBackground?.highlightedImage = UIImage(named: "message_sender_background_highlight")?.resizableImageWithCapInsets(UIEdgeInsetsMake(28, 20, 15, 20), resizingMode: UIImageResizingMode.Stretch)
            break
        case .Other:
            self.imageViewAvatar?.hidden = false
            self.imageViewAvatar?.image = UIImage(named: message.from!.avatarURL)
            self.imageViewMessageBackground?.hidden = false
            self.imageViewMessageBackground?.image = UIImage(named: "message_receiver_background_normal")?.resizableImageWithCapInsets(UIEdgeInsetsMake(28, 20, 15, 20), resizingMode: UIImageResizingMode.Stretch)
            self.imageViewMessageBackground?.highlightedImage = UIImage(named: "message_receiver_background_highlight")?.resizableImageWithCapInsets(UIEdgeInsetsMake(28, 20, 15, 20), resizingMode: UIImageResizingMode.Stretch)
            break
        case .System:
            self.imageViewAvatar?.hidden = true
            self.imageViewMessageBackground?.hidden = true
            break
        default: break
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func createImageViewAvatar() {
        if self.imageViewAvatar == nil {
            let imageWidth: CGFloat = 40
            self.imageViewAvatar = UIImageView(frame: CGRectMake(0, 0, imageWidth, imageWidth))
            self.imageViewAvatar?.hidden = true
            self.addSubview(self.imageViewAvatar!)
        }
    }
    
    private func createImageViewMessageBackground() {
        if self.imageViewMessageBackground == nil {
            self.imageViewMessageBackground = UIImageView()
            self.imageViewMessageBackground?.hidden = true
            self.addSubview(self.imageViewMessageBackground!)
        }
    }
}
