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
    @IBOutlet weak var movingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("fifth view did load")
        UIView.animateWithDuration(0.25, animations: {
            self.movingView.frame.origin.x = self.view.bounds.width - self.movingView.frame.width
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
//        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.Autoreverse, animations: {
//            self.vcLabel.frame.origin.x = 0
//        }, completion: nil)
//        self.vcLabel.reverseXAnimation(0.5, startX: self.vcLabel.frame.origin.x, endX: 0)
        
        
//        println("fifth view did appear")
//        UIView.animateWithDuration(0.25, animations: {
//            self.movingView.frame.origin.x = self.view.bounds.width - self.movingView.frame.width
//        })
        print("fifth view did appear")
    }
    

    @IBAction func presentAnother(sender: UIButton) {
        let willPresentVC = RTView.viewController("Main", storyboardID: "PresentedViewController") as! PresentedViewController
        self.presentViewController(willPresentVC, animated: true, completion: {
            print("presentedViewController has been presented, its presentingViewController is \(willPresentVC.presentingViewController)")
        })
    }
}
