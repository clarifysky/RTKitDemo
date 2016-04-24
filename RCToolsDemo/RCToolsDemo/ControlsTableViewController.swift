//
//  IndexTableViewController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 30/10/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit


class ControlsTableViewController: UITableViewController {
    
    let actions = ["UICollectionView", "CustomizedNavigation", "RedLayer", "UILabel", "UIImage", "TextField"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.title = "Controls"
    }
    
    func popVC(row: Int) {
        if row == 0 {
            let destVC = RTView.viewController("Controls", storyboardID: "ZeroGapViewController") as! ZeroGapViewController
            self.navigationController?.pushViewController(destVC, animated: true)
        } else if row == 1 {
            let destVC = RTView.viewController("Controls", storyboardID: "CustomizedNavigationController") as! CustomizedNavigationController
            self.presentViewController(destVC, animated: true, completion: nil)
        } else if row == 2 {
            let destVC = RTView.viewController("Controls", storyboardID: "BadgeViewController") as! BadgeViewController
            self.presentViewController(destVC, animated: true, completion: nil)
        } else if row == 3 {
            let destVC = RTView.viewController("Controls", storyboardID: "LabelViewController") as! LabelViewController
            self.presentViewController(destVC, animated: true, completion: nil)
        } else if row == 4 {
            let destVC = RTView.viewController("Controls", storyboardID: "ImageViewController") as! ImageViewController
            self.presentViewController(destVC, animated: true, completion: nil)
        } else if row == 5 {
            let destVC = RTView.viewController("Controls", storyboardID: "TextFieldViewController") as! TextFieldViewController
            self.navigationController?.pushViewController(destVC, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.actions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("controls", forIndexPath: indexPath) 
        cell.textLabel?.text = self.actions[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.popVC(indexPath.row)
    }

}
