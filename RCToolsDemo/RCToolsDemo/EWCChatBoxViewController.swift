//
//  EWCChatBoxViewController.swift
//  
//
//  Created by Rex Tsao on 2/26/16.
//
//

import UIKit

protocol ChatBoxViewControllerDelegate {
    func chatBoxViewController(chatBoxViewController: EWCChatBoxViewController, didChangeChatBoxHeight height: CGFloat)
    func chatBoxViewController(chatBoxViewController: EWCChatBoxViewController, sendMessage message: EWCMessage)
}

class EWCChatBoxViewController: UIViewController {

    private var keyboardFrame: CGRect?
    private var chatBox: EWCChatBox?
    var delegate: ChatBoxViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.greenColor()
        // Do any additional setup after loading the view.
        self.createChatBox()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardFrameWillChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    private func createChatBox() {
        if self.chatBox == nil {
            self.chatBox = EWCChatBox(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 49))
            self.chatBox?.delegate = self
            self.view.addSubview(self.chatBox!)
        }
    }
    
    override func resignFirstResponder() -> Bool {
        self.chatBox?.resignFirstResponder()
        UIView.animateWithDuration(0.3, animations: {
            self.delegate?.chatBoxViewController(self, didChangeChatBoxHeight: self.chatBox!.currentHeight!)
            }, completion: {
                finished in
                
        })
        return super.resignFirstResponder()
    }
    
    func keyboardWillHide(notification: NSNotification) {
        println("[EWCChatBoxViewController] keyboardWillHide:")
        
        self.keyboardFrame = CGRectZero
        self.delegate?.chatBoxViewController(self, didChangeChatBoxHeight: self.chatBox!.currentHeight!)
    }
    
    func keyboardFrameWillChange(notification: NSNotification) {
        println("[EWCChatBoxViewController] keyboardFrameWillChange:")
        
        if let userInfo = notification.userInfo {
            self.keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
//            self.view.frame.origin = CGPointMake(self.view.frame.origin.x, self.view.frame.origin.y - (self.keyboardFrame!.height))
            
            // Here, the animation is derived by default keyboard-show animation?
            self.delegate?.chatBoxViewController(self, didChangeChatBoxHeight: self.keyboardFrame!.height + self.chatBox!.currentHeight!)
        }
    }
}


extension EWCChatBoxViewController: ChatBoxDelegate {

    func chatBox(changeStatusFrom from: ChatBoxStatus, to toStatus: ChatBoxStatus) {
        if toStatus == .ShowKeyboard {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(0.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                
            })
            return
        } else {
            println("[EWCChatBoxViewController] change to other status")
        }
    }
    
    func chatBox(chatBox: EWCChatBox, changeChatBoxHeight height: CGFloat) {
        let h = self.keyboardFrame!.height + height
        self.delegate?.chatBoxViewController(self, didChangeChatBoxHeight: h)
    }
    
    func chatBox(chatBox: EWCChatBox, sendTextMessage textMessage: String) {
        let message = EWCMessage()
        message.messageType = .Text
        message.ownerType = .Mine
        message.text = textMessage
        message.date = NSDate()
        self.delegate?.chatBoxViewController(self, sendMessage: message)
    }
}