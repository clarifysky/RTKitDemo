//
//  FifthViewController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 9/10/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class FifthViewController: UIViewController {

    @IBOutlet weak var vcLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
//        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.Autoreverse, animations: {
//            self.vcLabel.frame.origin.x = 0
//        }, completion: nil)
        self.vcLabel.reverseXAnimation(0.5, startX: self.vcLabel.frame.origin.x, endX: 0)
    }
    

    @IBAction func presentAnother(sender: UIButton) {
        let willPresentVC = UIStoryboard.VCWithSpecificSBAndSBID(SBName: "Main", SBID: "PresentedViewController") as! PresentedViewController
        self.presentViewController(willPresentVC, animated: true, completion: {
            println("presentedViewController has been presented, its presentingViewController is \(willPresentVC.presentingViewController)")
        })
    }
}
