//
//  EWCViewController.swift
//  
//
//  Created by Rex Tsao on 2/26/16.
//
//

import UIKit

class EWCViewController: UIViewController {

    private var chatBoxVC: EWCChatBoxViewController?
    private var chatMessageVC: EWCChatMessageViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        self.attachChatMessageVC()
        self.attachChatBoxVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    private func attachChatBoxVC() {
        if self.chatBoxVC == nil {
            self.chatBoxVC = EWCChatBoxViewController()
            self.chatBoxVC?.view.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height - 49, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
            self.chatBoxVC?.delegate = self
            self.view.addSubview(self.chatBoxVC!.view)
            self.addChildViewController(self.chatBoxVC!)
        }
    }
    
    private func attachChatMessageVC() {
        if self.chatMessageVC == nil {
            self.chatMessageVC = EWCChatMessageViewController()
            // 20: height of status bar
            // 44: height of navigation bar
            self.chatMessageVC?.view.frame = CGRectMake(0, 20 + 44, UIScreen.mainScreen().bounds.width, self.view.bounds.height - 49 - (20 + 44))
            self.chatMessageVC?.delegate = self
            self.view.addSubview(self.chatMessageVC!.view)
            self.addChildViewController(self.chatMessageVC!)
        }
    }
}

extension EWCViewController: ChatBoxViewControllerDelegate {
    func chatBoxViewController(chatBoxViewController: EWCChatBoxViewController, didChangeChatBoxHeight height: CGFloat) {
        println("[EWCViewController] didChangeChatBoxHeight")
        
        self.chatMessageVC!.view.frame = CGRectMake(self.chatMessageVC!.view.frame.origin.x, self.chatMessageVC!.view.frame.origin.y, self.chatMessageVC!.view.frame.width, self.view.frame.height - height - (20 + 44))
        self.chatBoxVC?.view.frame.origin = CGPointMake(self.chatBoxVC!.view.frame.origin.x, self.chatMessageVC!.view.frame.origin.y + self.chatMessageVC!.view.frame.height)
        self.chatMessageVC?.scrollToBottom()
        
        
        
//        UIView.animateWithDuration(0.25, animations: {
//            self.chatMessageVC!.view.frame = CGRectMake(self.chatMessageVC!.view.frame.origin.x, self.chatMessageVC!.view.frame.origin.y, self.chatMessageVC!.view.frame.width, self.view.frame.height - height - (20 + 44))
//            self.chatBoxVC?.view.frame.origin = CGPointMake(self.chatBoxVC!.view.frame.origin.x, self.chatMessageVC!.view.frame.origin.y + self.chatMessageVC!.view.frame.height)
//            }, completion: {
//                finished in
//                println("animation finished")
//                println("__frame of chatMessgeVC: \(self.chatMessageVC!.view.frame)")
//                println("__frame of chatBoxVC: \(self.chatBoxVC!.view.frame)")
//                self.chatMessageVC?.scrollToBottom()
//        })
    }
    
    func chatBoxViewController(chatBoxViewController: EWCChatBoxViewController, sendMessage message: EWCMessage) {
        message.from = EWCUser()
        self.chatMessageVC?.addNewMessage(message)
        
        let recMessage = EWCMessage()
        recMessage.messageType = message.messageType
        recMessage.ownerType = .Other
        recMessage.date = NSDate()
        recMessage.text = message.text
        recMessage.imagePath = message.imagePath
        recMessage.from = message.from
        self.chatMessageVC?.addNewMessage(recMessage)
        
        self.chatMessageVC?.scrollToBottom()
    }
}

extension EWCViewController: ChatMessageViewControllerDelegate {
    func didTapChatMessageView(chatMessageViewController: EWCChatMessageViewController) {
        self.chatBoxVC?.resignFirstResponder()
    }
}
