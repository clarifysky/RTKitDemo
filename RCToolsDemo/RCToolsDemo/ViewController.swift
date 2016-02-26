//
//  ViewController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 17/9/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let actions = ["windowMask", "scenesTransition", "shadowView", "components", "graphic", "controls", "experiment"]
    let cellIdentifier = "tools"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        println("\(RCTools.Window().keyWindow()?.subviews.count)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindFromSubVC(sender: UIStoryboardSegue) {
    }
    
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        let segue = UIStoryboardSegue(identifier: identifier, source: fromViewController, destination: toViewController)
        return segue
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.actions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = self.actions[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.actions[indexPath.row] == "components" {
            let destinationVC = UIStoryboard.VCWithSpecificSBAndSBID(SBName: "Components", SBID: "ComponentsTableViewController") as! ComponentsTableViewController
            self.navigationController?.pushViewController(destinationVC, animated: true)
        } else if self.actions[indexPath.row] == "graphic" {
            let destinationVC = UIStoryboard.VCWithSpecificSBAndSBID(SBName: "Graphic", SBID: "GraphicTableViewController") as! GraphicTableViewController
            self.navigationController?.pushViewController(destinationVC, animated: true)
        } else if self.actions[indexPath.row] == "controls" {
            let destinationVC = UIStoryboard.VCWithSpecificSBAndSBID(SBName: "Controls", SBID: "ControlsTableViewController") as! ControlsTableViewController
            self.navigationController?.pushViewController(destinationVC, animated: true)
        } else if self.actions[indexPath.row] == "experiment" {
            let destVC = EWCViewController()
            self.navigationController?.pushViewController(destVC, animated: true)
        } else {
            performSegueWithIdentifier(self.actions[indexPath.row], sender: self)   
        }
    }
}

