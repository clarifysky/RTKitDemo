//
//  EWCChatBox.swift
//  
//
//  Created by Rex Tsao on 2/26/16.
//
//

import UIKit

protocol ChatBoxDelegate {
    func chatBox(chatBox: EWCChatBox, sendTextMessage textMessage: String)
    func chatBox(chatBox: EWCChatBox, changeChatBoxHeight height: CGFloat)
}

class EWCChatBox: UIView {

    private var topLine: UIView?
    private var voiceButton: UIButton?
    private var textView: UITextView?
    private var currentHeight: CGFloat?
    var delegate : ChatBoxDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.addSubview(self.createTopLine()!)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func createTopLine() -> UIView? {
        if self.topLine == nil {
            self.topLine = UIView(frame: CGRectMake(0, 0, 0, 0.5))
            self.topLine?.backgroundColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1.0)
        }
        return self.topLine
    }
    
    private func createVoiceButton() -> UIButton? {
        if self.voiceButton == nil {
            self.voiceButton = UIButton(frame: CGRectMake(0, (49-37)/2, 37, 37))
            self.voiceButton?.setImage(UIImage(named: "ToolViewInputVoice"), forState: .Normal)
            self.voiceButton?.setImage(UIImage(named: "ToolViewInputVoiceHL"), forState: .Highlighted)
        }
        return self.voiceButton
    }
    
    private func createTextView() -> UITextView? {
        if self.textView == nil {
            self.textView = UITextView(frame: CGRectMake(self.voiceButton!.frame.origin.x + self.voiceButton!.frame.width + 4, 5, 200, self.frame.height - 20))
            self.textView?.font = UIFont.systemFontOfSize(16)
            self.textView?.layer.masksToBounds = true
            self.textView?.layer.cornerRadius = 4.0
            self.textView?.layer.borderWidth = 0.5
            self.textView?.layer.borderColor = self.topLine?.backgroundColor?.CGColor
            self.textView?.scrollsToTop = false
            self.textView?.returnKeyType = .Send
            self.textView?.delegate = self
        }
        return self.textView
    }
    
    private func sendCurrentMessage() {
        if count(self.textView!.text) > 0 {
            self.delegate?.chatBox(self, sendTextMessage: self.textView!.text)
        }
        self.textView?.text = ""
        self.textViewDidChange(self.textView!)
    }
}


extension EWCChatBox: UITextViewDelegate {
    // 49: HEIGHT_TABBAR
    // 104: MAX_TEXTVIEW_HEIGHT
    // 49 * 0.74: HEIGHT_TEXTVIEW
    func textViewDidChange(textView: UITextView) {
        var height = textView.sizeThatFits(CGSizeMake(self.textView!.frame.width, CGFloat(MAXFLOAT))).height
        height = height > 49 * 0.74 ? height : 49 * 0.74
        height = height < 104 ? height : self.textView!.frame.height
        self.currentHeight = height + 49 - 49 * 0.74
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