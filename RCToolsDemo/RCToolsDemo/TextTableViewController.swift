//
//  TextTableViewController.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 20/4/2016.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

class TextTableViewController: UITableViewController {

    let actions = ["label"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "textCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    private func pushVC(index: Int) {
        if index == 0 {
            
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.actions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("textCell")! as UITableViewCell
        cell.textLabel?.text = self.actions[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.pushVC(indexPath.row)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
