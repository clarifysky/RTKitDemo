//
//  EWCUser.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 2/26/16.
//  Copyright (c) 2016 rexcao. All rights reserved.
//

import Foundation

class EWCUser {
    var userName: String = "小测测"
    var userId: String = "li-bokun"
    var nickName: String?
    var avatarURL: String = "0.jpg"
    var motto: String?
    var phoneNumber: String?
    
    var pinyin: String?
    var initial: String?
    
    func setUserName (userName: String) {
        self.userName = userName
        self.pinyin = "xx"
        self.initial = "yy"
    }
}