//
//  BeenPresentedViewController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 18/9/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class BeenPresentedViewController: UIViewController {

    var testTool: TestWindowMask?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("-been presented vc did load")
//        self.testTool = TestWindowMask()
//        self.testTool?.showMask()
//        self.testTool?.addTapGesutreToMask()
    }
    
    override func viewDidAppear(animated: Bool) {
        print("been presented vc did appear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismissVc(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func toNextVC(sender: UIButton) {
        let secondVC = RTView.viewController("Main", storyboardID: "SecondBeenPresentedViewController")
        presentViewController(secondVC, animated: true, completion: nil)
    }
}
