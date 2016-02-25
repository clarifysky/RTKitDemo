//
//  GlimmerViewController.swift
//  RCToolsDemo
//
//  Created by Apple on 10/21/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class GlimmerViewController: UIViewController {
    
    var testLabel: UILabel?
    var gradientMask: CAGradientLayer?
    var glimmerView: RCGlimmer?
    
    var glimmerButton: UIButton?
    var glimmerButtonAnimationing: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.blackColor()
        
        let testLabel = UILabel(frame: CGRectMake(10, 65, 100, 30))
        testLabel.text = "滑动来解锁"
        testLabel.font = UIFont.systemFontOfSize(18)
        testLabel.sizeToFit()
        testLabel.backgroundColor = UIColor.blackColor()
        testLabel.textColor = UIColor.whiteColor()
        self.testLabel = testLabel
        self.view.addSubview(self.testLabel!)
        
        self.attachGradientMask()
        self.attachAnimations()
        
        self.attachFlexibleGlimmer()
        self.attachExtensionGlimmer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func attachGradientMask() {
        let gradientMask = CAGradientLayer()
        // 让渐变层向左边多延伸一点，这样，动画就需要运行左边的部分，而这些是不可见的，这样，就造成了
        // 运行一点后暂歇一下的现象?
        // Make mask more width at left, this will make a pause animation
        //        gradientMask.frame = CGRectMake(-100, 0, self.testLabel!.bounds.width+100, self.testLabel!.bounds.height)
        gradientMask.frame = self.testLabel!.bounds
        gradientMask.colors = [UIColor(white: 1.0, alpha: 0.3).CGColor, UIColor.greenColor().CGColor, UIColor(white: 1.0, alpha: 0.3).CGColor]
        
        // In order to make animations start from left edge to right edge,
        // you should set correct startPoint and endPoint
        // Section for locations is from 0 to 1.
        // Point for startPoint and endPoint is not same to normal, it's the coordinate of layer.
        // (0.5, 0.5) is the center point of layer.
        gradientMask.startPoint = CGPointMake(-0.3, 0.5)
        gradientMask.endPoint = CGPointMake(1.3, 0.5)
        gradientMask.locations = [0, 0.15, 0.3]
        self.gradientMask = gradientMask
        
        self.testLabel!.layer.mask = self.gradientMask!
    }
    
    func attachAnimations() {
        // This animation will be applied on the locations of gradient.
        // So its keyPath is locations?
        let testAnimation = CABasicAnimation(keyPath: "locations")
        testAnimation.fromValue = [0, 0.15, 0.3]
        testAnimation.toValue = [1-0.3, 1-0.15, 1]
        testAnimation.repeatCount = Float.infinity
        testAnimation.duration = 1
        testAnimation.delegate = self
        
        self.gradientMask?.addAnimation(testAnimation, forKey: "test")
    }
    
    func attachFlexibleGlimmer() {
        let glimmerView = RCGlimmer(frame: CGRectMake(10, 85, 150, 30))
        let button = UIButton(frame: glimmerView.bounds)
        button.setTitle("Glimmer", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: "toggleGlimmer", forControlEvents: .TouchUpInside)
        glimmerView.addSubview(button)
        glimmerView.RCAnimationDuration = 2.0
        glimmerView.glimmer = true
        self.glimmerView = glimmerView
        self.view.addSubview(self.glimmerView!)
    }
    
    func toggleGlimmer() {
        self.glimmerView!.glimmer = !self.glimmerView!.glimmer
    }
    
    func attachExtensionGlimmer() {
        self.glimmerButton = UIButton()
        self.glimmerButton!.setTitle("extension Glimmer", forState: .Normal)
        self.glimmerButton!.addTarget(self, action: "toggleExtensionGlimmer", forControlEvents: .TouchUpInside)
        self.glimmerButton!.sizeToFit()
        self.glimmerButton?.frame.origin = CGPointMake(10, 115)
        self.glimmerButton!.RCGlimmer()
        self.view.addSubview(self.glimmerButton!)
        self.glimmerButtonAnimationing = true
    }
    
    func toggleExtensionGlimmer() {
        self.glimmerButton?.RCGlimmerToggle(!self.glimmerButtonAnimationing!)
        self.glimmerButtonAnimationing = !self.glimmerButtonAnimationing!
    }
}
