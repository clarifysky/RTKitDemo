//
//  SixViewController.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 26/4/2016.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

class SixViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        label.text = "This is the sixth view controller"
        label.backgroundColor = UIColor.greenColor()
        label.sizeToFit()
        label.setOrigin(CGPointMake(0, 100))
        RTPrint.shareInstance().prt("frame of label: \(label.frame)")
        self.view.addSubview(label)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
