//
//  RTRC.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 5/18/16.
//  Copyright © 2016 rexcao. All rights reserved.
//

import Foundation

class RTRC {
    private var stack: Dictionary<String, Int>
    
    init(key: String) {
        self.stack = [key: 0]
    }
    
    func add(key: String, count: Int) {
    }
    
    func increaseForKey(key: String) {
        var value = self.stack[key]!
        value += 1
        self.stack[key] = value
    }
    
    func decreaseForKey(key: String) {
        var value = self.stack[key]!
        value -= 1
        if value < 0 {
            value = 0
        }
        self.stack[key] = value
    }
    
    func valueForKey(key: String) -> Int {
        return self.stack[key]!
    }
}
