//
//  MenuViewController.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 5/19/16.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    private var table: UITableView?
    private let list = ["custom menu button", "cell1", "cell2"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.attachTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func attachTable() {
        self.table = UITableView(frame: self.view.bounds)
        self.table?.delegate = self
        self.table?.dataSource = self
        self.table?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "menu")
        self.table?.tableFooterView = UIView()
//        self.table?.separatorInset = UIEdgeInsetsZero
//        self.table?.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.view.addSubview(self.table!)
    }
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .Began {
            let cell = recognizer.view as! UITableViewCell
//            if (cell as? UITableViewCell) != nil {
//                print("you hint cell")
//            }
            
            cell.becomeFirstResponder()
            
            let headPhone = UIMenuItem(title: "headPhone", action: #selector(MenuViewController.headPhone(_:)))
            let speaker = UIMenuItem(title: "speaker", action: #selector(MenuViewController.speaker(_:)))
            let menu = UIMenuController.sharedMenuController()
            menu.menuItems = [headPhone, speaker]
            menu.setTargetRect(cell.frame, inView: cell.superview!)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func headPhone(sender: UIMenuItem) {
        print("tapped headPhone")
    }
    
    func speaker(sender: UIMenuItem) {
        print("tapped speaker")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(touches.first?.view)
        if (touches.first?.view as? UITableViewCell) != nil {
            print("cell")
        }
    }

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Three methos below used to handle copy.
    // Tell delegate to perform a copy or paste action.
//    func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
//        let board = UIPasteboard.generalPasteboard()
//        board.string = self.list[indexPath.row]
//    }
//    
//    func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
//        if action == #selector(NSObject.copy(_:)) {
//            return true
//        }
//        return false
//    }
//    
//    // Ask the delegate whether the editing menu should show in a certain row.
//    func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menu")! as UITableViewCell
        cell.textLabel?.text = self.list[indexPath.row]
        let longGR = UILongPressGestureRecognizer(target: self, action: #selector(MenuViewController.handleLongPress(_:)))
//        cell.userInteractionEnabled = true
        cell.separatorInset = UIEdgeInsetsZero
        cell.addGestureRecognizer(longGR)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(MenuCustomCellViewController(), animated: true)
        }
    }
}

