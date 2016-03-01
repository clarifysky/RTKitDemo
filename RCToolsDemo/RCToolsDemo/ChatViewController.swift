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
    
    private let navHeight: CGFloat = 0
    private let textViewWidth: CGFloat = 200
    private let textViewHeight: CGFloat = 40
    private var dataText: [String] = ["test1", "test2"]
    private var tableViewInitialHeight: CGFloat = 0
    private var textViewInitialOriginY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "chat"

        // Do any additional setup after loading the view.
        self.createTableView()
        self.createTextView()
        // gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: "viewDidTapped:")
        self.view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardFrameWillChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
    }

    private func createTableView() {
        self.tableView = UITableView(frame: CGRectMake(0, self.navHeight, self.view.bounds.width, self.view.bounds.height - (self.navHeight + self.textViewHeight)))
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "textCell")
        self.tableViewInitialHeight = self.tableView!.frame.height
        self.view.addSubview(self.tableView!)
    }
    
    private func createTextView() {
        let x = RCTools.Math.xyInParentBorder(borderLengthOfParentView: self.view.bounds.width, borderLengthOfSelf: self.textViewWidth)
        self.textView = UITextView(frame: CGRectMake(x, self.tableView!.frame.origin.y + self.tableView!.frame.height, self.textViewWidth, self.textViewHeight))
        self.textView?.layer.borderColor = UIColor.grayColor().CGColor
        self.textView?.layer.borderWidth = 0.5
        self.textView?.layer.cornerRadius = 5
        self.textView?.clipsToBounds = true
        self.textView?.delegate = self
        self.textView?.font = UIFont.systemFontOfSize(16)
        self.textViewInitialOriginY = self.textView!.frame.origin.y
        self.view.addSubview(self.textView!)
    }
    
    private func sendMessage() {
        let message = self.textView!.text
        self.dataText.append(message)
        self.tableView?.reloadData()
        self.textView?.text = ""
        self.textViewDidChange(self.textView!)
        self.tableScrollToBottom()
    }
    
    func keyboardFrameWillChange(notification: NSNotification) {
        println("[ChatViewController] keyboardFrameWillChange:")
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.changeViewFrame(keyboardSize.height)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        println("[ChatViewController] keyboardWillHide:")
        self.changeViewFrame(0)
    }

    private func changeViewFrame(height: CGFloat) {
        self.tableView?.frame = CGRectMake(self.tableView!.frame.origin.x, self.tableView!.frame.origin.y, self.tableView!.frame.width, self.tableViewInitialHeight - height)
        self.textView?.frame = CGRectMake(self.textView!.frame.origin.x, self.textViewInitialOriginY - height, self.textView!.frame.width, self.textView!.frame.height)
        self.tableScrollToBottom()
//        self.view.frame = CGRectMake(self.view.frame.origin.x, 0 - height, self.view.frame.width, self.view.frame.height)
    }
    
    func viewDidTapped(recognizer: UITapGestureRecognizer) {
        if recognizer.view != self.textView && self.textView!.isFirstResponder() {
            self.textView?.resignFirstResponder()
        }
    }
    
    private func tableScrollToBottom() {
        self.tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: self.dataText.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataText.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("textCell") as! UITableViewCell
        cell.textLabel?.text = self.dataText[indexPath.row]
        return cell
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
        println("[TextFieldViewController] textViewDidChange:")
        // Caculate the size which best fits the specified size.
        // This height is just the height of textView which best fits its content.
        var height = textView.sizeThatFits(CGSizeMake(self.textView!.frame.width, CGFloat(MAXFLOAT))).height
        // Compare with the original height, if bigger than original value, use current height, otherwise, use original value
        height = height > self.textViewHeight ? height : self.textViewHeight
        // Here i set the max height for textView is 80.
        if height <= 80 {
            // Get how much the textView grows at height dimission
            let heightDiff = height - self.textView!.frame.height
            UIView.animateWithDuration(0.05, animations: {
                self.tableView?.frame = CGRectMake(self.tableView!.frame.origin.x, self.tableView!.frame.origin.y - heightDiff, self.tableView!.frame.width, self.tableView!.frame.height)
                self.textView?.frame = CGRectMake(self.textView!.frame.origin.x, self.textView!.frame.origin.y - heightDiff, self.textView!.frame.width, height)
            })
        }
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            println("You pressed return button")
            self.sendMessage()
            return false
        } else {
            return true
        }
    }
}
