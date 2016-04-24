//
//  AnimationCircleViewController.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 19/4/2016.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

let π = CGFloat(M_PI)
class AnimationCircleViewController: UIViewController {

    private var index: CGFloat = 0
    private let maxStep: CGFloat = 8
    private var prevValue: CGFloat = 0.0
    private var circleLayer: CAShapeLayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let greenViewSize: CGFloat = 100
        let greenView = UIView(frame: CGRectMake(100, 200, greenViewSize, greenViewSize))
        greenView.backgroundColor = UIColor.greenColor()
        greenView.layer.cornerRadius = greenViewSize / 2
        self.view.addSubview(greenView)
        
        let playButton = UIButton()
        playButton.setTitle("play", forState: .Normal)
        playButton.setTitleColor(UIColor.colorWithRGB(0, green: 0, blue: 0), forState: .Normal)
        playButton.sizeToFit()
        playButton.frame.origin = CGPointMake(30, 140)
        playButton.addTarget(self, action: #selector(AnimationCircleViewController.circleGrow), forControlEvents: .TouchUpInside)
        self.view.addSubview(playButton)
        
        let startAngle: CGFloat = 0
        let endAngle = 2 * π
        let ovalPath = UIBezierPath(arcCenter: CGPointMake(CGRectGetMidX(greenView.frame), CGRectGetMidY(greenView.frame)), radius: CGRectGetWidth(greenView.frame), startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        self.circleLayer = CAShapeLayer()
        circleLayer?.path = ovalPath.CGPath
        circleLayer?.fillColor = nil
        circleLayer?.lineWidth = 10.0
        circleLayer?.lineCap = kCALineCapRound
        circleLayer?.strokeColor = UIColor.blueColor().CGColor
        self.circleLayer!.strokeStart = 0
        self.view.layer.addSublayer(self.circleLayer!)
        
        // Set the initial strokeEnd to zero to ready for growth.
        self.circleLayer?.strokeEnd = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func circleGrow() {
        if self.index < self.maxStep {
            self.strokeLayer(self.index / self.maxStep, to: (self.index + 1) / self.maxStep, animated: true)
            self.index += 1
        }
        
    }
    
    private func strokeLayer(fromValue: CGFloat, to: CGFloat, animated: Bool) {
        var from = fromValue
        self.circleLayer!.strokeEnd = to
        if animated {
            // Check if there is any existing animation is in progress, if so override, the from value.
            if let circlePresentationLayer = self.circleLayer!.presentationLayer() {
                from = circlePresentationLayer.strokeEnd
            }
            
            // Remove any on going animation.
            if self.circleLayer?.animationForKey("circle") as? CABasicAnimation != nil {
                // Remove the current animation
                self.circleLayer!.removeAnimationForKey("circle")
            }
            
            let anim = CABasicAnimation(keyPath: "strokeEnd")
            anim.duration = 1
            anim.fromValue = from
            anim.toValue = to
            
            self.circleLayer?.addAnimation(anim, forKey: "circle")
        }
    }

}
