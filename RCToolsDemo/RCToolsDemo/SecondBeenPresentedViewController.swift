//
//  SecondBeenPresentedViewController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 18/9/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class SecondBeenPresentedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        RTPrint.shareInstance().prt("-second vc did load")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        RTPrint.shareInstance().prt("second vc did appear")
    }

    @IBAction func dismissVC(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
