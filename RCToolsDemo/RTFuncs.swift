//
//  RTFuncs.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 29/5/2016.
//  Copyright © 2016 rexcao. All rights reserved.
//

import Foundation

func rtprint(items: Any, separator: String = ", ", terminator: String = "\n") {
    RTPrint.shareInstance().prt(items, separator: separator, terminator: terminator)
}