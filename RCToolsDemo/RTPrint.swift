//
//  RTPrint.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 5/27/16.
//  Copyright © 2016 rexcao. All rights reserved.
//

import Foundation

class RTPrint {
    var disable: Bool = false
    
    class func shareInstance() -> RTPrint {
        var predicate: dispatch_once_t = 0
        var instance: RTPrint?
        dispatch_once(&predicate, {
            instance = RTPrint()
        })
        return instance!
    }
    
    /// print any data
    func prt(items: Any) {
        guard !self.disable else {
            return
        }
        print(items)
    }
    
    /// print multiple items
    func prtm(items: Any..., separator: String = " ", terminator: String = "\n") {
        guard !self.disable else {
            return
        }
        print(items, separator: separator, terminator: terminator)
    }
}