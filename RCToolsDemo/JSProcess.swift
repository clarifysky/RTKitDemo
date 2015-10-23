//
//  JSProcess.swift
//  RCToolsDemo
//
//  Created by Apple on 10/23/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import Foundation
import UIKit
import JavaScriptCore

protocol JavaScriptSwiftDelegate: JSExport {
    func callSystemCamera()
    func showAlert(title: String, msg: String)
    func callWithDict(dict: Dictionary<String, AnyObject>)
    func jsCallSwiftAndSwiftCallJsWithDict(dict: Dictionary<String, AnyObject>)
}

class JSSwiftModel: NSObject, JavaScriptSwiftDelegate {
    weak var controller: UIViewController?
    weak var jsContext: JSContext?
    
    func callSystemCamera() {
        print("js call objc method: callSystemCamera");
        let jsFunc = self.jsContext?.objectForKeyedSubscript("jsFunc");
        jsFunc?.callWithArguments([]);
    }
    
    func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: nil))
        self.controller?.presentViewController(alert, animated: true, completion: nil)
    }
    
    func callWithDict(dict: [String : AnyObject]) {
        print("js call objc method: callWithDict, args: %@", dict)
    }
    
    func jsCallSwiftAndSwiftCallJsWithDict(dict: [String : AnyObject]) {
        print("js call objc method: jsCallSwiftAndSwiftCallJsWithDict, args: %@", dict)
        let jsParamFunc = self.jsContext?.objectForKeyedSubscript("jsParamFunc");
        let dict = NSDictionary(dictionary: ["age": 18, "height": 168, "name": "lili"])
        jsParamFunc?.callWithArguments([dict]) 
    }
}

