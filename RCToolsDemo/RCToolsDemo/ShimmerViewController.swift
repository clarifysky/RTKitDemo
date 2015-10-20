//
//  ShimmerViewController.swift
//  RCToolsDemo
//
//  Created by Apple on 10/20/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit
import Shimmer

class ShimmerViewController: UIViewController {
    
    var shimmerView: FBShimmeringView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var currentY: CGFloat = 65
        
        // Shimmer
        let testLabel = UILabel(frame: CGRectMake(0, currentY, self.view.bounds.width, self.view.bounds.height))
        testLabel.text = "This effect finished with Shimmer's help. https://github.com/facebook/Shimmer"
//        testLabel.textColor = UIColor.whiteColor()
        testLabel.numberOfLines = 0
        testLabel.sizeToFit()
        self.view.addSubview(testLabel)
        currentY += testLabel.frame.height + 10
        
        self.shimmerView = FBShimmeringView(frame: CGRectMake(10, currentY, 150, 40))
        let shimmerLabel = UILabel(frame: self.shimmerView!.bounds)
        shimmerLabel.text = "Shimmer"
        self.shimmerView?.contentView = shimmerLabel
        self.view.addSubview(self.shimmerView!)
        currentY += self.shimmerView!.frame.height + 10
        
        // Toggle
        let startButton = UIButton()
        startButton.setTitle("Start", forState: .Normal)
        startButton.sizeToFit()
        startButton.addTarget(self, action: "toggleShimmer", forControlEvents: .TouchUpInside)
        startButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: startButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleShimmer() {
        self.shimmerView!.shimmering = !self.shimmerView!.shimmering
    }
}
