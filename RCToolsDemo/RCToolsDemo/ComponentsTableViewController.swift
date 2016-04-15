//
//  ComponentsTableViewController.swift
//  RCToolsDemo
//
//  Created by Apple on 10/20/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit
import RTKit

class ComponentsTableViewController: UITableViewController {

    let actions = ["paragraph", "dictionary", "gallery", "audio", "chat", "addressBook"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.title = "Components"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func popVC(row: Int) {
        if row == 0 {
            let destVC = RTView.viewController("Components", storyboardID: "newImageOrigin") as! ParagraphViewController
            self.navigationController?.pushViewController(destVC, animated: true)
        } else if row == 1 {
            let destVC = RTView.viewController("Components", storyboardID: "DictionaryViewController") as! DictionaryViewController
            self.navigationController?.pushViewController(destVC, animated: true)
        } else if row == 2 {
            let destVC = RTView.viewController("Components", storyboardID: "GalleryBrowserViewController") as! GalleryBrowserViewController
            self.navigationController?.pushViewController(destVC, animated: true)
        } else if row == 3 {
            let destVC = RTView.viewController("Components", storyboardID: "AudioViewController") as! AudioViewController
            self.navigationController?.pushViewController(destVC, animated: true)
        } else if row == 4 {
            
            let destVC = ChatViewController()
            self.navigationController?.pushViewController(destVC, animated: true)
        } else if row == 5 {
            self.navigationController?.pushViewController(AddressBookViewController(), animated: true)
        }
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
        let cell = tableView.dequeueReusableCellWithIdentifier("components", forIndexPath: indexPath) 

        // Configure the cell...
        cell.textLabel?.text = self.actions[indexPath.row]

        return cell
    }

}
