//
//  RTError.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 5/12/16.
//  Copyright © 2016 rexcao. All rights reserved.
//

import Foundation

enum RTErrorType: ErrorType {
    case Nil
    case Other
}

enum RTErrorLevel {
    case Notice
    case Warnning
    case Error
}

class RTError {
    var level: RTErrorLevel?
    var title: String?
    var description: String?
    var code: Int?
    
    init(title: String, code: Int) {
        self.title = title
        self.code = code
    }
}