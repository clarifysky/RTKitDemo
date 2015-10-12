//
//  ShadowController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 12/10/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class ShadowViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addShadow(sender: UIBarButtonItem) {
        let curveShadow = CurveShadowView(alignment: .horizontal, length: 300, anchor: CGPointMake(10, 100))
        self.view.addSubview(curveShadow)
    }
}
