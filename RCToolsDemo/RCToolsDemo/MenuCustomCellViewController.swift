//
//  MenuCustomCellViewController.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 5/19/16.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

class MenuCustomCellViewController: UIViewController {

    private var table: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.attachTable()
        RTPrint.shareInstance().disable = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    private func attachTable() {
        self.table = UITableView(frame: self.view.bounds)
        self.table?.delegate = self
        self.table?.dataSource = self
//        self.table?.registerClass(MenuButtonTableViewCell.self, forCellReuseIdentifier: "menuButton")
        self.view.addSubview(self.table!)
    }
    
    func headPhone(sender: UIMenuItem) {
        RTPrint.shareInstance().disable = true
        let test = ["1", "2", "3"]
        RTPrint.shareInstance().prt(test)
    }
    
    func speaker(sender: UIMenuItem) {
        RTPrint.shareInstance().disable = false
        RTPrint.shareInstance().prt(4, 5, "hello", separator: "< ", terminator: "\n")
    }
    
    func tapped(sender: MenuButton) {
        RTPrint.shareInstance().prt("you tapped the button")
    }
    
    func test(sender: UIMenuItem) {
        RTPrint.shareInstance().prt("test")
    }
}

extension MenuCustomCellViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("menuButton") as? MenuButtonTableViewCell
        if cell == nil {
            cell = MenuButtonTableViewCell(style: .Default, reuseIdentifier: "menuButton")
            
            if indexPath.row == 0 {
                cell?.menuButton?.blockForMenu = {
                    let test = UIMenuItem(title: "test0", action: #selector(MenuCustomCellViewController.test(_:)))
                    cell?.menuButton?.menu?.menuItems = [test]
                }
            } else {
                cell?.menuButton?.blockForMenu = {
                    let headPhone = UIMenuItem(title: "headPhone", action: #selector(MenuCustomCellViewController.headPhone(_:)))
                    let speaker = UIMenuItem(title: "speaker", action: #selector(MenuCustomCellViewController.speaker(_:)))
                    cell?.menuButton?.menu?.menuItems = [headPhone, speaker]
                }
            }
            cell?.menuButton?.addTarget(self, action: #selector(MenuCustomCellViewController.tapped(_:)), forControlEvents: .TouchUpInside)
        }
        return cell!
    }
}
