//
//  EWCChatBoxViewController.swift
//  
//
//  Created by Rex Tsao on 2/26/16.
//
//

import UIKit

class EWCChatBoxViewController: UIViewController {

    private var chatBox: EWCChatBox?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}


extension EWCChatBoxViewController: ChatBoxDelegate {
    func chatBox(chatBox: EWCChatBox, changeChatBoxHeight height: CGFloat) {
        
    }
    
    func chatBox(chatBox: EWCChatBox, sendTextMessage textMessage: String) {
        
    }
}