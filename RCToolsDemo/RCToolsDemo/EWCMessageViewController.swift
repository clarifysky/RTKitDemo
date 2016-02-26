//
//  EWCMessageViewController.swift
//  
//
//  Created by Rex Tsao on 2/26/16.
//
//

import UIKit

class EWCMessageViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .None
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
