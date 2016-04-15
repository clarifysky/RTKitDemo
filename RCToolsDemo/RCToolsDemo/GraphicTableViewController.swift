//
//  GraphicTableViewController.swift
//  RCToolsDemo
//
//  Created by Apple on 10/28/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit
import RTKit

class GraphicTableViewController: UITableViewController {
    
    let actions = ["carMoving", "snapshot", "bezierpath", "dynamicBehaviors", "glimmer", "autoLayout"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.title = "Graphic"
    }
    
    func popVC(row: Int) {
        if row == 0 {
            let destVC = RTView.viewController("Graphic", storyboardID: "CarMovingViewController") as! CarMovingViewController
            self.navigationController?.pushViewController(destVC, animated: true)
        } else if row == 1 {
            let destVC = RTView.viewController("Graphic", storyboardID: "SnapshotViewController") as! SnapshotViewController
            self.navigationController?.pushViewController(destVC, animated: true)
        } else if row == 2 {
            let destVC = RTView.viewController("Graphic", storyboardID: "BezierPathViewController") as! BezierPathViewController
            self.navigationController?.pushViewController(destVC, animated: true)
        } else if row == 3 {
            let destVC = RTView.viewController("Graphic", storyboardID: "DynamicBehaviorViewController") as! DynamicBehaviorViewController
            self.navigationController?.pushViewController(destVC, animated: true)
        } else if row == 4 {
            let destVC = RTView.viewController("Graphic", storyboardID: "GlimmerViewController") as! GlimmerViewController
            self.navigationController?.pushViewController(destVC, animated: true)
        } else if row == 5 {
            let destVC = RTView.viewController("Graphic", storyboardID: "AutoLayoutViewController") as! AutoLayoutViewController
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.popVC(indexPath.row)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("graphic")! as UITableViewCell
        cell.textLabel?.text = self.actions[indexPath.row]
        
        return cell
    }
}
