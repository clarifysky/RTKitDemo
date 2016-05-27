//
//  WithNavBeenPresentedViewController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 18/9/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class WithNavBeenPresentedViewController: UIViewController {

    var testTool: TestWindowMask?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        RTPrint.shareInstance().prt("-withNavVC did load")
        self.testTool = TestWindowMask()
        self.testTool?.showMask()
//        self.testTool?.addTapGesutreToMask()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        RTPrint.shareInstance().prt("-withNavVC did appear")
    }
    
    
    @IBAction func dismissVC(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    


}
