//
//  GraphicTableViewController.swift
//  RCToolsDemo
//
//  Created by Apple on 10/28/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit


class GraphicTableViewController: UITableViewController {
    
    let actions = ["carMoving", "snapshot", "bezierpath", "dynamicBehaviors", "glimmer", "autoLayout", "animations"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Graphic"
        
        self.navigationController?.navigationBar.RTBackgroundColor(UIColor.clearColor())
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        // Tell the delegate when user scroll the scroll view.
        self.scrollViewDidScroll(self.tableView)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.RTReset()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let color = UIColor.colorWithRGB(45, green: 45, blue: 45, alpha: 1)
        let offsetY = scrollView.contentOffset.y
        
        let halfHeight = UIScreen.mainScreen().bounds.height / 2
        
        if offsetY >= -halfHeight - 64 {
            let alphat = min(1, (halfHeight + 64 + offsetY) / halfHeight)
            self.navigationController?.navigationBar.RTBackgroundColor(color.colorWithAlphaComponent(alphat))
        } else {
            self.navigationController?.navigationBar.RTBackgroundColor(color.colorWithAlphaComponent(0))
        }
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
        } else if row == 6 {
            self.navigationController?.pushViewController(AnimationTableViewController(), animated: true)
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
