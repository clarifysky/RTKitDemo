//
//  ThirdViewController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 29/9/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        RTPrint.shareInstance().prt("third VC loaded")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
