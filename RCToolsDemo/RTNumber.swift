//
//  RTNumber.swift
//  RTKit
//
//  Created by Rex Tsao on 8/4/2016.
//  Copyright © 2016 rexcao.net. All rights reserved.
//

import Foundation

class RTNumber {
    /// Prefix zero for specific number. Only when the number is less than 10,
    /// will this function prefix zero for it.
    class func prefixZero(number: Int) -> String {
        let res = number < 10 ? "0" + String(number) : String(number)
        return res
    }
}