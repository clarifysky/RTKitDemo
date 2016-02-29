//
//  EWCChatHelper.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 2/26/16.
//  Copyright (c) 2016 rexcao. All rights reserved.
//

import Foundation

class EWCChatHelper {
    
//    class func formatStringToFitMessage(text: String) -> NSAttributedString {
//        // 1. Create a mutable string.
//        var attributeString = NSMutableAttributedString(string: text)
//        // 2. Match string by regex.
//        var regexEmoji = "\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]" // Match emoji face
//        
//        var error: NSError? = nil
//        var re = NSRegularExpression(pattern: regexEmoji, options: NSRegularExpressionOptions.CaseInsensitive, error: &error)
//        if re == nil {
//            println(error?.localizedDescription)
//            return attributeString
//        }
//        
//        var resultArray: NSArray? = re?.matchesInString(text, options: NSMatchingOptions.allZeros, range: NSMakeRange(0, count(text)))
//        // 3. Get all the faces and their position
//        var imageArray = NSMutableArray(capacity: resultArray!.count)
//        for tmp in resultArray! {
//            var match = tmp as! NSTextCheckingResult
//            var range = match.range
//            var subStr = (text as NSString).substringWithRange(range)
//        }
//    }
}