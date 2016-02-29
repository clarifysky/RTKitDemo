//
//  EWCMessage.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 2/26/16.
//  Copyright (c) 2016 rexcao. All rights reserved.
//

import Foundation
import MapKit

/// Type of message owner.
enum MessageOwnerType {
    case Unknown
    case System
    case Mine
    case Other
}

/// Type of message.
enum MessageType {
    case Unknown
    case System
    case Text
    case Image
    case Voice
    case Video
    case File
    case Location
    case Shake
}

// State of message which to be send.
enum MessageSendState {
    case Success
    case Fail
}

// State of message which to be read.
enum MessageReadState {
    case UnRead
    case Read
}

class EWCMessage {
    /// Information about sender.
    var from: EWCUser?
    var date: NSDate?
    var dateString: String?
    var messageType: MessageType?
    var ownerType: MessageOwnerType?
    var readState: MessageReadState?
    var sendState: MessageSendState?
    
    var messageSize: CGSize?
    var cellHeight: CGFloat?
    var cellIdentity: String?
    
    var text: String?
    var attrText: NSAttributedString?
    
    var imagePath: String?
    var image: UIImage?
    var imageURL: String?
    
    private var coordinate: CLLocationCoordinate2D?
    private var address: String?
    
    private var voiceSeconds: Int?
    private var voiceURL: String?
    private var voicePath: String?
    
    private var label: UILabel? = nil
    
    init() {
        if self.label == nil {
            self.label = UILabel()
            self.label?.numberOfLines = 0
            self.label?.font = UIFont.systemFontOfSize(16)
        }
    }
    
    func setText(text: String) {
        self.text = text
        if count(text) > 0 {
        }
    }
}