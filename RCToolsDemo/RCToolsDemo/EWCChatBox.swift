//
//  EWCChatBox.swift
//  
//
//  Created by Rex Tsao on 2/26/16.
//
//

import UIKit

enum ChatBoxStatus {
    case Nothing
    case ShowVoice
    case ShowFace
    case ShowMore
    case ShowKeyboard
}

protocol ChatBoxDelegate {
    func chatBox(changeStatusFrom from: ChatBoxStatus, to toStatus: ChatBoxStatus)
    func chatBox(chatBox: EWCChatBox, sendTextMessage textMessage: String)
    func chatBox(chatBox: EWCChatBox, changeChatBoxHeight height: CGFloat)
}

class EWCChatBox: UIView {

    private var topLine: UIView?
    private var voiceButton: UIButton?
    private var textView: UITextView?
    var currentHeight: CGFloat?
    var delegate : ChatBoxDelegate?
    var status: ChatBoxStatus?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.currentHeight = self.frame.height
        self.backgroundColor = UIColor.whiteColor()
        self.createTopLine()
        self.createVoiceButton()
        self.createTextView()
        self.status = .Nothing
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func createTopLine() {
        if self.topLine == nil {
            self.topLine = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 0.5))
            self.topLine?.backgroundColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1.0)
        }
        self.addSubview(self.topLine!)
    }
    
    private func createVoiceButton() {
        if self.voiceButton == nil {
            self.voiceButton = UIButton(frame: CGRectMake(0, (49-37)/2, 37, 37))
            self.voiceButton?.setImage(UIImage(named: "ToolViewInputVoice"), forState: .Normal)
            self.voiceButton?.setImage(UIImage(named: "ToolViewInputVoiceHL"), forState: .Highlighted)
        }
        self.addSubview(self.voiceButton!)
    }
    
    private func createTextView() {
        if self.textView == nil {
            self.textView = UITextView(frame: CGRectMake(self.voiceButton!.frame.origin.x + self.voiceButton!.frame.width + 4, 5, 200, self.frame.height - 10))
            self.textView?.font = UIFont.systemFontOfSize(16)
            self.textView?.layer.masksToBounds = true
            self.textView?.layer.cornerRadius = 4.0
            self.textView?.layer.borderWidth = 0.5
            self.textView?.layer.borderColor = self.topLine?.backgroundColor?.CGColor
            self.textView?.scrollsToTop = false
            self.textView?.returnKeyType = .Send
            self.textView?.delegate = self
        }
        self.addSubview(self.textView!)
    }
    
    private func sendCurrentMessage() {
        if count(self.textView!.text) > 0 {
            self.delegate?.chatBox(self, sendTextMessage: self.textView!.text)
        }
        self.textView?.text = ""
        self.textViewDidChange(self.textView!)
    }
    
    private func setFrame(frame: CGRect) {
        self.topLine?.frame = CGRectMake(self.topLine!.frame.origin.x, self.topLine!.frame.origin.y, self.frame.width, self.topLine!.frame.height)
        
        var y = self.frame.height - self.voiceButton!.frame.height - (49 - 37) / 2
        if self.voiceButton!.frame.origin.y != y {
            UIView.animateWithDuration(0.1, animations: {
                self.voiceButton!.frame.origin = CGPointMake(self.voiceButton!.frame.origin.x, y)
            })
        }
    }
    
    override func resignFirstResponder() -> Bool {
        self.textView?.resignFirstResponder()
        return super.resignFirstResponder()
    }
    
    func deleteButtonDown() {
        self.textView(self.textView!, shouldChangeTextInRange: NSMakeRange(count(self.textView!.text) - 1, 1), replacementText: "")
        self.textViewDidChange(self.textView!)
    }
}


extension EWCChatBox: UITextViewDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
        let lastStatus = self.status!
        self.status = .ShowKeyboard
        self.delegate?.chatBox(changeStatusFrom: lastStatus, to: self.status!)
    }
    
    
    // 49: HEIGHT_TABBAR
    // 104: MAX_TEXTVIEW_HEIGHT
    // 49 * 0.74: HEIGHT_TEXTVIEW
    func textViewDidChange(textView: UITextView) {
        println("[EWCChatBox] textViewDidChange:")
        var height = textView.sizeThatFits(CGSizeMake(self.textView!.frame.width, CGFloat(MAXFLOAT))).height
        height = height > textView.frame.height ? height : textView.frame.height
        height = height < 104 ? height : textView.frame.height
        self.currentHeight = height + 49 - textView.frame.height
        if self.currentHeight != self.frame.height {
            UIView.animateWithDuration(0.05, animations: {
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width, self.currentHeight!)
                if self.delegate != nil {
                    self.delegate?.chatBox(self, changeChatBoxHeight: self.currentHeight!)
                }
            })
        }
        
        if height != self.textView!.frame.height {
            UIView.animateWithDuration(0.05, animations: {
                self.textView?.frame = CGRectMake(self.textView!.frame.origin.x, self.textView!.frame.origin.y, self.textView!.frame.width, height)
            })
        }
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.sendCurrentMessage()
            return false
        }
        return true
    }
}