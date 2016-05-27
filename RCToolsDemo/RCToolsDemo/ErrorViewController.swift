//
//  ErrorViewController.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 5/12/16.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.attachComputeButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func attachComputeButton() {
        let comButton = UIButton()
        comButton.setTitle("compute", forState: .Normal)
        comButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        comButton.sizeToFit()
        comButton.setOrigin(CGPointMake(0, 64))
        comButton.addTarget(self, action: #selector(ErrorViewController.compute), forControlEvents: .TouchUpInside)
        self.view.addSubview(comButton)
    }
    
    private func sum() throws -> Int {
        let a = 1
        var b: Int?
        b = nil
        
        guard b != nil else {
            throw RTErrorType.Nil
        }
        
        return a + b!
    }
    
    func compute() {
        do {
            try self.sum()
        } catch RTErrorType.Nil {
            RTPrint.shareInstance().prt("nil error occurs")
        } catch {
            RTPrint.shareInstance().prt("other errors")
        }
    }
}
