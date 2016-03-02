//
//  ChatMessage.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 3/2/16.
//  Copyright (c) 2016 rexcao. All rights reserved.
//

import Foundation

enum MessageType: Int {
    case Text = 0
    case Voice = 1
}

class ChatMessage {
    var portrait: UIImage?
    var message: String?
}