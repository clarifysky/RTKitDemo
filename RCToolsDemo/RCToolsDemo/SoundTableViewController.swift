//
//  SoundTableViewController.swift
//  
//
//  Created by Rex Tsao on 3/9/16.
//
//

import UIKit

class SoundTableViewController: UITableViewController {

    private let categories = ["vibrate", "audio"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "AudioList"
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "text")
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
        return self.categories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("text", forIndexPath: indexPath) 

        // Configure the cell...
        cell.textLabel?.text = self.categories[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(VibrateViewController(), animated: true)
        } else if indexPath.row == 1 {
            self.navigationController?.pushViewController(AudioStreamViewController(), animated: true)
        }
    }

}
