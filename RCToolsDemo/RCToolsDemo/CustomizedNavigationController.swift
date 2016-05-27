//
//  CustomizedNavigationController.swift
//  RCToolsDemo
//
//  Created by Apple on 11/3/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class CustomizedNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.attachBottomBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func attachBottomBar() {
        let bottomBar = UIView(frame: CGRectMake(0, self.view.bounds.height - 40, self.view.bounds.width, 40))
        bottomBar.backgroundColor = UIColor.grayColor()
        let testButton = UIButton(frame: CGRectMake(0, 0, 40, 40))
        testButton.setTitle("BT", forState: .Normal)
        testButton.addTarget(self, action: #selector(CustomizedNavigationController.tapTest), forControlEvents: .TouchUpInside)
        bottomBar.addSubview(testButton)
        self.view.addSubview(bottomBar)
    }
    
    func tapTest() {
        RTPrint.shareInstance().prt("you tapped a button on navigationController")
    }
}
