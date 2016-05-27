//
//  PresentedViewController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 9/10/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class PresentedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {
            RTPrint.shareInstance().prt("presentedViewController has been dismissed")
        })
    }

}
