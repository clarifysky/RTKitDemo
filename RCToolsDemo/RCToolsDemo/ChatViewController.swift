//
//  ChatViewController.swift
//  
//
//  Created by Rex Tsao on 3/1/16.
//
//

import UIKit

class ChatViewController: UIViewController {

    private var textView: UITextView?
    private var tableView: UITableView?
    private var containerTextView: UIView?
    
    private let navHeight: CGFloat = 0
    private let textViewWidth: CGFloat = 200
    private let textViewHeight: CGFloat = 40
//    private var dataText: [String] = ["test1", "test2"]
    private var data: [ChatMessage] = [ChatMessage]()
    private var tableViewInitialHeight: CGFloat = 0
    private var textViewInitialOriginY: CGFloat = 0
    private var containerTextViewInitialOriginY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "chat"
        
        self.insertTestData()

        // Do any additional setup after loading the view.
        self.createTableView()
        self.createTextView()
        // gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.viewDidTapped(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func insertTestData() {
        let message1 = ChatTextMessage(ownerType: .Mine, messageType: .Text, portrait: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("10", ofType: "jpeg")!)!)
        message1.text = "This is a long text for testing attributedText, here i will insert some emojis : 🙂😎😚😶😝. Is this will be correct?"
        let message2 = ChatTextMessage(ownerType: .Other, messageType: .Text, portrait: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("10", ofType: "jpeg")!)!)
        message2.text = "This is another long text for testing attributedText, here i will insert some emojis : 🙂😎😚😶😝. Is this will be correct?"
        let message3 = ChatVoiceMessage(ownerType: .Mine, messageType: .Voice, portrait: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("10", ofType: "jpeg")!)!, voiceSecs: 5)
        let message4 = ChatVoiceMessage(ownerType: .Other, messageType: .Voice, portrait: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("10", ofType: "jpeg")!)!, voiceSecs: 45)
        let message5 = ChatVoiceMessage(ownerType: .Mine, messageType: .Voice, portrait: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("10", ofType: "jpeg")!)!, voiceSecs: 100)
        let message6 = ChatVoiceMessage(ownerType: .Other, messageType: .Voice, portrait: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("10", ofType: "jpeg")!)!, voiceSecs: 60)
        let message7 = ChatVoiceMessage(ownerType: .Other, messageType: .Voice, portrait: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("10", ofType: "jpeg")!)!, voiceSecs: 0)
        self.data.append(message1)
        self.data.append(message2)
        self.data.append(message3)
        self.data.append(message4)
        self.data.append(message5)
        self.data.append(message6)
        self.data.append(message1)
        self.data.append(message2)
        self.data.append(message7)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardFrameWillChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        self.tableScrollToBottom()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
    }

    private func createTableView() {
        self.tableView = UITableView(frame: CGRectMake(0, self.navHeight, self.view.bounds.width, self.view.bounds.height - (self.navHeight + self.textViewHeight + 20)))
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
//        self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "textCell")
        self.tableView?.registerClass(ChatTextCell.self, forCellReuseIdentifier: "textMessageCell")
        self.tableView?.registerClass(ChatVoiceCell.self, forCellReuseIdentifier: "voiceMessageCell")
        self.tableViewInitialHeight = self.tableView!.frame.height
        self.tableView?.separatorStyle = .None
        self.view.addSubview(self.tableView!)
    }
    
    private func createTextView() {
        self.containerTextView = UIView(frame: CGRectMake(0, self.tableView!.frame.origin.y + self.tableView!.frame.height, self.view.bounds.width, self.textViewHeight + 20))
        self.containerTextViewInitialOriginY = self.containerTextView!.frame.origin.y
        let topLine = UIView(frame: CGRectMake(0, 0, self.containerTextView!.bounds.width, 0.5))
        topLine.backgroundColor = UIColor.grayColor()
        
        let origin = RTMath.centerOrigin(self.containerTextView!.frame.size, childSize: CGSizeMake(self.textViewWidth, self.textViewHeight))
        self.textView = UITextView(frame: CGRectMake(origin.x, origin.y, self.textViewWidth, self.textViewHeight))
        self.textView?.layer.borderColor = UIColor.grayColor().CGColor
        self.textView?.layer.borderWidth = 0.5
        self.textView?.layer.cornerRadius = 5
        self.textView?.clipsToBounds = true
        self.textView?.delegate = self
        self.textView?.font = UIFont.systemFontOfSize(16)
        self.textView?.returnKeyType = .Send
        self.textViewInitialOriginY = self.textView!.frame.origin.y
        
        self.containerTextView!.addSubview(topLine)
        self.containerTextView!.addSubview(self.textView!)
        
        self.view.addSubview(self.containerTextView!)
    }
    
    private func sendMessage() {
//        let message = self.textView!.text
//        self.dataText.append(message)
        let message = ChatTextMessage(ownerType: .Mine, messageType: .Text, portrait: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("10", ofType: "jpeg")!)!)
        message.text = self.textView!.text
        self.data.append(message)
        
        let message1 = ChatTextMessage(ownerType: .Other, messageType: .Text, portrait: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("10", ofType: "jpeg")!)!)
        message1.text = self.textView!.text
        self.data.append(message1)
        
        
        self.tableView?.reloadData()
        self.textView?.text = ""
        self.textViewDidChange(self.textView!)
        self.tableScrollToBottom()
    }
    
    func keyboardFrameWillChange(notification: NSNotification) {
        RTPrint.shareInstance().prt("[ChatViewController] keyboardFrameWillChange:")
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.changeViewFrame(keyboardSize.height)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        RTPrint.shareInstance().prt("[ChatViewController] keyboardWillHide:")
        self.changeViewFrame(0)
    }

    private func changeViewFrame(height: CGFloat) {
        self.tableView?.frame = CGRectMake(self.tableView!.frame.origin.x, self.tableView!.frame.origin.y, self.tableView!.frame.width, self.tableViewInitialHeight - height)
//        self.textView?.frame = CGRectMake(self.textView!.frame.origin.x, self.textViewInitialOriginY - height, self.textView!.frame.width, self.textView!.frame.height)
        self.containerTextView?.frame = CGRectMake(self.containerTextView!.frame.origin.x, self.containerTextViewInitialOriginY - height, self.containerTextView!.frame.width, self.containerTextView!.frame.height)
        self.tableScrollToBottom()
//        self.view.frame = CGRectMake(self.view.frame.origin.x, 0 - height, self.view.frame.width, self.view.frame.height)
    }
    
    func viewDidTapped(recognizer: UITapGestureRecognizer) {
        if recognizer.view != self.textView && self.textView!.isFirstResponder() {
            self.textView?.resignFirstResponder()
        }
    }
    
    private func tableScrollToBottom() {
        self.tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: self.data.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat = 60
        let message = self.data[indexPath.row]
        if message.messageType == .Text {
//            var cell = tableView.cellForRowAtIndexPath(indexPath) as? ChatTextCell
            let cell = ChatTextCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
            
            height = (message as! ChatTextMessage).messageSize!.height + 2 * cell.gapLabelMessage + 2 * cell.gapPortrait
        }
        return height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = self.data[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(message.cellIdentity) as! ChatCell
        if message.messageType == .Text {
            (cell as! ChatTextCell).setMessage(message)
            return cell as! ChatTextCell
        } else {
            // voice
            (cell as! ChatVoiceCell).setMessage(message)
            return cell as! ChatVoiceCell
        }
    }
}

extension ChatViewController: UITextViewDelegate {
    
    // If you want to reset the height of UITextView dynamically:
    // 1. You must set the upper limit of height for the UITextView. If you don't set the upper limit, the UITextView
    //      will grow much high as it can, this may not be what you want.
    // 2. Calculate the height when it best fits its contents.
    // 3. Calculate the gap of old height and new height.
    // 4. Reset its frame.
    // IMPORTANT: Only when the new height is less than the upper limit you set, the frame of UITextView can be reset.
    func textViewDidChange(textView: UITextView) {
        RTPrint.shareInstance().prt("[TextFieldViewController] textViewDidChange:")
        // Caculate the size which best fits the specified size.
        // This height is just the height of textView which best fits its content.
        var height = textView.sizeThatFits(CGSizeMake(self.textView!.frame.width, CGFloat(MAXFLOAT))).height
        // Compare with the original height, if bigger than original value, use current height, otherwise, use original value
        height = height > self.textViewHeight ? height : self.textViewHeight
        // Here i set the max height for textView is 80.
        if height <= 104 {
            // Get how much the textView grows at height dimission
            let heightDiff = height - self.textView!.frame.height
            UIView.animateWithDuration(0.05, animations: {
                self.tableView?.frame = CGRectMake(self.tableView!.frame.origin.x, self.tableView!.frame.origin.y - heightDiff, self.tableView!.frame.width, self.tableView!.frame.height)
//                self.textView?.frame = CGRectMake(self.textView!.frame.origin.x, self.textView!.frame.origin.y - heightDiff, self.textView!.frame.width, height)
                self.textView?.frame = CGRectMake(self.textView!.frame.origin.x, self.textView!.frame.origin.y, self.textView!.frame.width, height)
                self.containerTextView?.frame = CGRectMake(self.containerTextView!.frame.origin.x, self.containerTextView!.frame.origin.y - heightDiff, self.containerTextView!.frame.width, self.containerTextView!.frame.height + heightDiff)
            })
        }
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            RTPrint.shareInstance().prt("You pressed return button")
            self.sendMessage()
            return false
        } else {
            return true
        }
    }
}
