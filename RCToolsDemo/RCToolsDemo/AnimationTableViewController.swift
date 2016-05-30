//
//  AnimationTableViewController.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 19/4/2016.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

class AnimationTableViewController: UITableViewController {

    let actions = ["circle", "gravity", "attachment", "snap", "push", "catScroll"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Animation"
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "animationCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func pushVC(index: Int) {
        if index == 0 {
            self.navigationController?.pushViewController(AnimationCircleViewController(), animated: true)
        } else if index == 1 {
            self.navigationController?.pushViewController(GravityViewController(), animated: true)
        } else if index == 2 {
            self.navigationController?.pushViewController(AttachmentViewController(), animated: true)
        } else if index == 3 {
            self.navigationController?.pushViewController(SnapViewController(), animated: true)
        } else if index == 4 {
            self.navigationController?.pushViewController(PushViewController(), animated: true)
        } else if index == 5 {
            self.navigationController?.pushViewController(ScrollCatViewController(), animated: true)
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.actions.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.pushVC(indexPath.row)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("animationCell")! as UITableViewCell
        cell.textLabel?.text = self.actions[indexPath.row]
        return cell
    }
    
}
