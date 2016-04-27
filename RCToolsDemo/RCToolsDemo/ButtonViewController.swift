//
//  ButtonViewController.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 27/4/2016.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

class ButtonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.attachCompactButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Create a button which its content is closed to its boundary.
    private func attachCompactButton() {
        let compactButton = UIButton(type: .Custom)
        
        compactButton.setTitle("Compact", forState: .Normal)
        compactButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        // You should set contentEdgeInsets before sizeToFit was called.
        compactButton.contentEdgeInsets = UIEdgeInsetsMake(-1, 0, -1, 0)
        compactButton.sizeToFit()
        compactButton.setOrigin(100, y: 100)
        
        compactButton.setBorder(UIColor.blueColor().CGColor, borderWidth: 1.0)
        compactButton.titleLabel?.setBorder(UIColor.greenColor().CGColor, borderWidth: 1.0)
        
        self.view.addSubview(compactButton)
    }
}
