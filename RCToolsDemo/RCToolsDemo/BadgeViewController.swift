//
//  BadgeViewController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 3/12/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class BadgeViewController: UIViewController {

    @IBOutlet weak var testButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.testButton.attachBadge()
        self.testButton.attachBadge(999)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
