//
//  ScrollCatViewController.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 30/5/2016.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

class ScrollCatViewController: UIViewController {

    private var imageViewCat: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.attachCat()
        self.attachKeyFrameAimationButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.fadeInScroll()
    }
    
    private func attachKeyFrameAimationButton () {
        let button = UIButton()
        button.setTitle("keyFrame", forState: .Normal)
        button.setTitleColor(UIColor.brownColor(), forState: .Normal)
        button.addTarget(self, action: #selector(ScrollCatViewController.doKeyFrameAnimation(_:)), forControlEvents: .TouchUpInside)
        button.sizeToFit()
        button.setOrigin(CGPointMake(0, 64))
        
        self.view.addSubview(button)
    }
    
    func doKeyFrameAnimation(sender: UIButton) {
//        let path = UIBezierPath()
//        path.moveToPoint(CGPointMake(300, self.imageViewCat!.y + self.imageViewCat!.height / 2))
//        path.addLineToPoint(CGPointMake(300, self.imageViewCat!.yBottom + 200))
//        path.addLineToPoint(CGPointMake(300, self.imageViewCat!.yBottom + 150))
//        
//        let keyAnimation = CAKeyframeAnimation(keyPath: "position")
//        keyAnimation.path = path.CGPath
//        keyAnimation.duration = 2
//        keyAnimation.removedOnCompletion = false
//        keyAnimation.fillMode = kCAFillModeForwards
//        self.imageViewCat?.layer.addAnimation(keyAnimation, forKey: "cat-bouncing")
        
        let yAnimation = CABasicAnimation(keyPath: "position.y")
        yAnimation.fromValue = self.imageViewCat!.y + self.imageViewCat!.height / 2
        yAnimation.toValue = self.imageViewCat!.yBottom + 200
        yAnimation.removedOnCompletion = false
        yAnimation.fillMode = kCAFillModeForwards
        yAnimation.delegate = self
        self.imageViewCat?.layer.addAnimation(yAnimation, forKey: "cat-down")
    }
    
    private func upAndScale() {
        let upAnimation = CABasicAnimation(keyPath: "position.y")
        upAnimation.fromValue = self.imageViewCat!.yBottom + 200
        upAnimation.toValue = self.imageViewCat!.yBottom + 150
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 1.5
        
        let upScaleGroup = CAAnimationGroup()
        upScaleGroup.animations = [upAnimation, scaleAnimation]
        upScaleGroup.removedOnCompletion = false
        upScaleGroup.fillMode = kCAFillModeForwards
        self.imageViewCat!.layer.addAnimation(upScaleGroup, forKey: "cat-up-scale")
    }
    
    private func attachCat() {
        self.imageViewCat = UIImageView(image: UIImage(named: "guapi"))
        self.imageViewCat?.clipsToBounds = true
        self.imageViewCat?.layer.opacity = 0
        self.imageViewCat?.frame = CGRectMake(0, 100, 100, 100)
        self.imageViewCat?.layer.cornerRadius = self.imageViewCat!.width / 2
        
        self.view.addSubview(self.imageViewCat!)
    }
    
    private func fadeInScroll() {
        let animationGroup = CAAnimationGroup()
        
        let positionAnimation = CABasicAnimation(keyPath: "position.x")
        positionAnimation.fromValue = self.imageViewCat!.x
        positionAnimation.toValue = 300
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2 * M_PI
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1
        
        animationGroup.animations = [positionAnimation, rotationAnimation, opacityAnimation]
        animationGroup.removedOnCompletion = false
        animationGroup.fillMode = kCAFillModeForwards
        animationGroup.duration = 2
        animationGroup.delegate = self
        self.imageViewCat?.layer.addAnimation(animationGroup, forKey: "cat-scroll")
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag {
            let keys = self.imageViewCat?.layer.animationKeys()
            print(keys)
            print(keys!.contains("cat-down"))
            if keys!.contains("cat-down") {
                self.upAndScale()
            }
        }
    }

}
