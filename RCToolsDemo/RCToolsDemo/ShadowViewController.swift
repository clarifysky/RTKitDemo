//
//  ShadowController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 12/10/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class ShadowViewController: UIViewController {

    @IBOutlet weak var needShadowView: UIView!
    private var curveShadowShowed: Bool = false
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
    
    @IBAction func toggleShadow(sender: UIButton) {
        if !self.curveShadowShowed {
            self.needShadowView.layer.RCCurveShadow(CurveShadowDirection.Left)
            self.curveShadowShowed = true
        } else {
            self.needShadowView.layer.shadowOpacity = 0.0
            self.needShadowView.layer.shadowOffset = CGSizeMake(0, 0)
            self.needShadowView.layer.shadowPath = nil
            self.curveShadowShowed = false
        }
    }
    
}
