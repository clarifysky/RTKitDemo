//
//  CarMovingViewController.swift
//  RCToolsDemo
//
//  Created by Apple on 10/28/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class CarMovingViewController: UIViewController {

    private var car: UIImageView?
    private var movingAnimation: CAKeyframeAnimation?
    private let animKey = "carMoving"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.car = self.buildCar()
        self.view.addSubview(self.car!)
        
        self.attachAnimation()
        
        // stop button
        let stopButton = UIButton(frame: CGRectMake(0, 0, 100, 20))
        stopButton.setTitle("Stop", forState: .Normal)
        stopButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        stopButton.addTarget(self, action: "stopCar", forControlEvents: .TouchUpInside)
        stopButton.sizeToFit()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stopButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildCar() -> UIImageView {
        let car = UIImageView(frame: CGRectMake(10, 64, 128, 128))
        car.image = UIImage(named: "muscle_car")
        return car
    }
    
    func attachAnimation() {
        // Animation direction depends on direction of its path drawing.
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(self.view.bounds.width + self.car!.frame.width, self.car!.frame.origin.y + self.car!.frame.height / 2))
        path.addLineToPoint(CGPointMake(0 - self.car!.frame.width, self.car!.frame.origin.y + self.car!.frame.height / 2))
        
        self.movingAnimation = CAKeyframeAnimation(keyPath: "position")
        self.movingAnimation?.path = path.CGPath
//        self.movingAnimation?.rotationMode = kCAAnimationRotateAuto
        self.movingAnimation?.repeatCount = Float.infinity
        self.movingAnimation?.duration = 2.0
        
        self.car!.layer.addAnimation(self.movingAnimation!, forKey: self.animKey)
    }
    
    func stopCar() {
        self.car!.layer.removeAnimationForKey(self.animKey)
    }
    
    
    @IBAction func pauseCar(sender: UIButton) {
        // Get the current media time
        let interval = self.car!.layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        // Set time offset to ensure that layer will stay at there when animation paused.
        self.car!.layer.timeOffset = interval
        // Set speed to 0 to pause animation.
        self.car!.layer.speed = 0
    }
    
    @IBAction func carContinue(sender: UIButton) {
        let beginTime = CACurrentMediaTime() - self.car!.layer.timeOffset
        self.car!.layer.timeOffset = 0
        self.car!.layer.beginTime = beginTime
        // 1.0 is normal speed?
        self.car!.layer.speed = 1.0
    }
}
