//
//  RCPopView.swift
//  RCToolsDemo
//
//  Created by Apple on 10/27/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class RCPop: UIView {
    
    private var messageLabel: UILabel?
    private var timer: NSTimer?
    
    init(frame: CGRect, message: String?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        self.layer.cornerRadius = 10
        
        self.messageLabel = UILabel(frame: CGRectMake(0, 0, frame.width, 20))
        self.messageLabel?.text = message
        self.messageLabel?.textColor = UIColor.whiteColor()
        self.messageLabel?.textAlignment = .Center
        self.messageLabel?.backgroundColor = UIColor.clearColor()
        let properSize = self.messageLabel?.sizeThatFits(CGSizeMake(3 * frame.width / 4, frame.height))
        
        let labelOrigin = RCTools.Math.originInParentView(sizeOfParentView: frame.size, sizeOfSelf: properSize!)
        self.messageLabel?.frame = CGRectMake(labelOrigin.x, labelOrigin.y, properSize!.width, properSize!.height)
        self.addSubview(self.messageLabel!)
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1), target: self, selector: "tick", userInfo: nil, repeats: true)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tick() {
        self.timer?.invalidate()
        self.removeFromSuperview()
    }
}
