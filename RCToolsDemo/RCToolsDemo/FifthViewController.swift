//
//  FifthViewController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 9/10/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class FifthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func presentAnother(sender: UIButton) {
        let willPresentVC = UIStoryboard.VCWithSpecificSBAndSBID(SBName: "Main", SBID: "PresentedViewController") as! PresentedViewController
        self.presentViewController(willPresentVC, animated: true, completion: {
            println("presentedViewController has been presented, its presentingViewController is \(willPresentVC.presentingViewController)")
        })
    }
}
