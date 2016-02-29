//
//  EWCMessageViewController.swift
//  
//
//  Created by Rex Tsao on 2/26/16.
//
//

import UIKit

protocol ChatMessageViewControllerDelegate {
    func didTapChatMessageView(chatMessageViewController: EWCChatMessageViewController)
}

class EWCChatMessageViewController: UITableViewController {

    private var tapGR: UITapGestureRecognizer?
    private var data: [EWCMessage]? = [EWCMessage]()
    var delegate: ChatMessageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.yellowColor()
        self.view.layer.borderColor = UIColor.redColor().CGColor
        self.view.layer.borderWidth = 0.5
        
        self.createTapGR()
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .None
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func createTapGR() {
        if self.tapGR == nil {
            self.tapGR = UITapGestureRecognizer(target: self, action: "didTapView:")
            self.view.addGestureRecognizer(self.tapGR!)
        }
    }
    
    func didTapView(recognizer: UITapGestureRecognizer) {
        self.delegate?.didTapChatMessageView(self)
    }
    
    func addNewMessage(message: EWCMessage) {
        self.data?.append(message)
        self.tableView.reloadData()
    }
    
    func scrollToBottom() {
        if self.data?.count > 0 {
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.data!.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var message = self.data![indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(message.cellIdentity!) as! EWCMessageCell
        switch message.messageType! {
        case .Text:
            cell = cell as! EWCTextMessageCell
            break
        case .Image:
            cell = cell as! EWCImageMessageCell
            break
        default:
            break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var message = self.data![indexPath.row]
        return message.cellHeight!
    }
}
