//
//  GraphicTableViewController.swift
//  RCToolsDemo
//
//  Created by Apple on 10/28/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class GraphicTableViewController: UITableViewController {
    
    let actions = ["carMoving", "snapshot", "bezierpath"]
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
            let destVC = UIStoryboard.VCWithSpecificSBAndSBID(SBName: "Graphic", SBID: "CarMovingViewController") as! CarMovingViewController
            self.navigationController?.pushViewController(destVC, animated: true)
        } else if row == 1 {
            let destVC = UIStoryboard.VCWithSpecificSBAndSBID(SBName: "Graphic", SBID: "SnapshotViewController") as! SnapshotViewController
            self.navigationController?.pushViewController(destVC, animated: true)
        } else if row == 2 {
            let destVC = UIStoryboard.VCWithSpecificSBAndSBID(SBName: "Graphic", SBID: "BezierPathViewController") as! BezierPathViewController
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
        let cell = tableView.dequeueReusableCellWithIdentifier("graphic") as! UITableViewCell
        cell.textLabel?.text = self.actions[indexPath.row]
        
        return cell
    }
}
