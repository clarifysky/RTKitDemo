//
//  TestNavigationController.swift
//  RCToolsDemo
//
//  Created by Apple on 11/3/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class TestNavigationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismissVC(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
