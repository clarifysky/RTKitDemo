//
//  RCGlimmer.swift
//  Shimmer
//
//  Created by Apple on 10/21/15.
//  Copyright (c) 2015 Breadth. All rights reserved.
//

import UIKit

class RCGlimmer: UIView {

    private var gradientMask: CAGradientLayer?
    private var gradientAnimation: CABasicAnimation?
    private let kTextAnimationKey = "gradientAnimation"
    var RCGradientColors: [AnyObject]? = [UIColor(white: 1.0, alpha: 0.3).CGColor, UIColor.greenColor().CGColor, UIColor(white: 1.0, alpha: 0.3).CGColor] {
        willSet {
            self.gradientMask?.colors = newValue
        }
    }
    var RCGradientLocations: [AnyObject]? = [0, 0.15, 0.3] {
        willSet {
            self.gradientMask?.locations = newValue
        }
    }
    var RCAnimationDuration: CFTimeInterval? = 1.0 {
        willSet {
            self.gradientAnimation?.duration = newValue!
        }
    }
    var glimmer: Bool = false {
        willSet {
            if newValue {
                self.start()
            } else {
                self.stop()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createGradientMask() {
        if self.gradientMask == nil {
            let gradientMask = CAGradientLayer()
            // 让渐变层向左边多延伸一点，这样，动画就需要运行左边的部分，而这些是不可见的，这样，就造成了
            // 运行一点后暂歇一下的现象?
            // Make mask more width at left, this will make a pause animation
            //        gradientMask.frame = CGRectMake(-100, 0, self.testLabel!.bounds.width+100, self.testLabel!.bounds.height)
            gradientMask.frame = self.bounds
            gradientMask.colors = self.RCGradientColors
            
            // In order to make animations start from left edge to right edge,
            // you should set correct startPoint and endPoint
            // Section for locations is from 0 to 1.
            // Point for startPoint and endPoint is not same to normal, it's the coordinate of layer.
            // (0.5, 0.5) is the center point of layer.
            gradientMask.startPoint = CGPointMake(-0.3, 0.5)
            gradientMask.endPoint = CGPointMake(1.3, 0.5)
            gradientMask.locations = self.RCGradientLocations
            self.gradientMask = gradientMask
        }
        
        self.layer.mask = self.gradientMask!
    }
    
    private func createAnimations() {
        if self.gradientAnimation == nil {
            // This animation will be applied on the locations of gradient.
            // So its keyPath is locations?
            let gradientAnimation = CABasicAnimation(keyPath: "locations")
            gradientAnimation.fromValue = [0, 0.15, 0.3]
            gradientAnimation.toValue = [1-0.3, 1-0.15, 1]
            gradientAnimation.repeatCount = Float.infinity
            gradientAnimation.duration = self.RCAnimationDuration!
            gradientAnimation.delegate = self
            self.gradientAnimation = gradientAnimation
        }
        
        self.gradientMask?.addAnimation(self.gradientAnimation, forKey: self.kTextAnimationKey)
    }
    
    private func start() {
        self.createGradientMask()
        self.createAnimations()
    }
    
    private func stop() {
        if self.gradientMask != nil && self.gradientAnimation != nil {
            self.layer.mask.removeAnimationForKey(self.kTextAnimationKey)
            self.layer.mask = nil
        }
    }
}

extension UIView {
    var RCkTextAnimationKey: String { return "gradientAnimation" }
    
    func RCGlimmer(
        RCGradientColors: [AnyObject] = [UIColor(white: 1.0, alpha: 0.3).CGColor, UIColor.greenColor().CGColor, UIColor(white: 1.0, alpha: 0.3).CGColor],
        RCGradientLocations: [AnyObject] = [0, 0.15, 0.3],
        RCAnimationDuration: CFTimeInterval = 1.0) {
            
            if self.layer.mask == nil {
                let gradientMask = CAGradientLayer()
                // 让渐变层向左边多延伸一点，这样，动画就需要运行左边的部分，而这些是不可见的，这样，就造成了
                // 运行一点后暂歇一下的现象?
                // Make mask more width at left, this will make a pause animation
                //        gradientMask.frame = CGRectMake(-100, 0, self.testLabel!.bounds.width+100, self.testLabel!.bounds.height)
                gradientMask.frame = self.bounds
                gradientMask.colors = RCGradientColors
                
                // In order to make animations start from left edge to right edge,
                // you should set correct startPoint and endPoint
                // Section for locations is from 0 to 1.
                // Point for startPoint and endPoint is not same to normal, it's the coordinate of layer.
                // (0.5, 0.5) is the center point of layer.
                gradientMask.startPoint = CGPointMake(-0.3, 0.5)
                gradientMask.endPoint = CGPointMake(1.3, 0.5)
                gradientMask.locations = RCGradientLocations
                self.layer.mask = gradientMask
            }
            
            if self.layer.mask.animationForKey(self.RCkTextAnimationKey) == nil {
                // This animation will be applied on the locations of gradient.
                // So its keyPath is locations?
                let gradientAnimation = CABasicAnimation(keyPath: "locations")
                gradientAnimation.fromValue = [0, 0.15, 0.3]
                gradientAnimation.toValue = [1-0.3, 1-0.15, 1]
                gradientAnimation.repeatCount = Float.infinity
                gradientAnimation.duration = RCAnimationDuration
                gradientAnimation.delegate = self
                self.layer.mask.addAnimation(gradientAnimation, forKey:
                    RCkTextAnimationKey)
            }
    }
    
    func RCGlimmerRemove() {
        if self.layer.mask.animationForKey(self.RCkTextAnimationKey) != nil {
            self.layer.mask.removeAnimationForKey(self.RCkTextAnimationKey)
        }
        if self.layer.mask != nil {
            self.layer.mask = nil
        }
    }
    
    func RCGlimmerToggle(launch: Bool) {
        if launch {
            self.RCGlimmer()
        } else {
            self.RCGlimmerRemove()
        }
    }
}
