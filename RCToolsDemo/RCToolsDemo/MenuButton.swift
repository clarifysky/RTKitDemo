//
//  MenuButton.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 5/19/16.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

class MenuButton: UIButton {
    
    var menu: UIMenuController?
    override init(frame: CGRect) {
        super.init(frame: frame)
        let longGR = UILongPressGestureRecognizer(target: self, action: #selector(MenuButton.longPress(_:)))
        self.addGestureRecognizer(longGR)
        self.menu = UIMenuController.sharedMenuController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func longPress(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .Began {
            self.becomeFirstResponder()
            
            self.menu?.setTargetRect(self.frame, inView: self.superview!)
            self.menu?.setMenuVisible(true, animated: true)
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
}
