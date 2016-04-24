//
//  BezierPathViewController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 6/11/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class BezierPathViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIGraphicsBeginImageContext(CGSizeMake(80, 80))
        let path = UIBezierPath(arcCenter: CGPointMake(40, 40), radius: 40, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        UIColor.redColor().setStroke()
        path.stroke()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let circleImageView = UIImageView(image: image)
        circleImageView.frame.origin = CGPointMake(0, 64)
        self.view.addSubview(circleImageView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
