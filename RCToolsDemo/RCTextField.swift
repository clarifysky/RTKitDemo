//
//  RCTextField.swift
//  
//
//  Created by Rex Cao on 17/2/2016.
//
//

import UIKit

class RCTextField: UITextField {
    var doneButton: UIButton?
    var doneTitle: String = "返回"
    var doneAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func keyboardDidHide(notification: NSNotification) {
        if self.doneButton != nil {
            self.doneButton?.hidden = true
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        var tempWindow: UIWindow? = nil
        var keyboard: UIView? = nil
        
        tempWindow = UIApplication.sharedApplication().windows[1] as? UIWindow
//        tempWindow = UIApplication.sharedApplication().windows[UIApplication.sharedApplication().windows.count - 1] as? UIWindow
        if tempWindow == nil {
            return
        }
        
        let viewCount = tempWindow!.subviews.count
        
        println("[windows count]: \(UIApplication.sharedApplication().windows.count)")
        // find keyboard view out.
        for i in 0..<viewCount {
            keyboard = tempWindow?.subviews[i] as? UIView
            println("[description]: \(keyboard?.description)")
            
            // keyboard view found, add custom button to it.
            if keyboard?.description.hasPrefix("<UIPeripheralHostView") == true || keyboard?.description.hasPrefix("<UIKeyboard") == true || keyboard?.description.hasPrefix("<UIInputSetContainerView") == true {
                println("found UIKeyboard or UIPeripheralHostView")
                self.createDoneButton()
                keyboard!.addSubview(self.doneButton!)
                break
            }
            
        }
    }
    
    private func createDoneButton() {
        if self.doneButton == nil {
            self.doneButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
            self.doneButton?.hidden = true
            self.doneButton?.setTitle(self.doneTitle, forState: .Normal)
            self.doneButton?.frame = CGRectMake(773/2.0, 250/2.0, 180/2.0, 68/2.0)
            self.doneButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.doneButton?.titleLabel?.font = UIFont.systemFontOfSize(16)
            
            self.doneButton?.addTarget(self, action: "donePressed", forControlEvents: .TouchUpInside)
            self.doneButton?.backgroundColor = UIColor.blackColor()
        }
        
        if self.editing {
            self.doneButton?.hidden = false
        } else {
            self.doneButton?.hidden = true
        }
    }
    
    
    func donePressed() {
        self.doneButton?.hidden = true
        self.resignFirstResponder()
        self.doneAction?()
    }
    
}
