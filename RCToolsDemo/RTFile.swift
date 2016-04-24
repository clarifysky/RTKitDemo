//
//  RTFile.swift
//  RTKit
//
//  Created by Rex Tsao on 9/4/2016.
//  Copyright © 2016 rexcao.net. All rights reserved.
//

import Foundation

class RTFile {
    class func removeFile(path: String) -> NSErrorPointer? {
        let errorPointer: NSErrorPointer? = nil
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(path) {
            do {
                try fileManager.removeItemAtPath(path)
            } catch let error as NSError {
                errorPointer!.memory = error
            }
        }
        return errorPointer
    }
    
    class func appDirectory(directory: NSSearchPathDirectory, domainMask: NSSearchPathDomainMask) -> String {
        let path = NSSearchPathForDirectoriesInDomains(directory, domainMask, true)
        return path[0]
    }
}