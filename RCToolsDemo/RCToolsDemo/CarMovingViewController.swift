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
        self.attachBlackView()
        self.view.backgroundColor = UIColor.orangeColor()
        
        self.car = self.buildCar()
        self.car?.frame.origin = CGPointMake(0, self.car!.frame.origin.y + self.car!.frame.height)
        self.view.addSubview(self.car!)
        
        self.attachAnimation()
//        self.attachTestLabel()
        
        // stop button
        let stopButton = UIButton(frame: CGRectMake(0, 0, 100, 20))
        stopButton.setTitle("Stop", forState: .Normal)
        stopButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        stopButton.addTarget(self, action: #selector(CarMovingViewController.stopCar), forControlEvents: .TouchUpInside)
        stopButton.sizeToFit()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stopButton)
        
        // transparent navigation bar
//        self.navigationController?.navigationBar.transparentBgColor(UIColor.colorWithRGB(0, green: 1, blue: 0, alpha: 0.4))
//        self.navigationController?.navigationBar.opaqueBgColor(UIColor.blueColor())
        self.navigationController?.navigationBar.RTBackgroundColor(UIColor.colorWithRGB(0, green: 1, blue: 0, alpha: 0.4))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.RTReset()
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
    
    private func attachBlackView() {
        let blackView = UIView(frame: CGRectMake(self.view.bounds.width / 2, 0, self.view.bounds.width / 2, self.view.bounds.height))
        blackView.backgroundColor = UIColor.blueColor()
        self.view.addSubview(blackView)
    }
    
    private func attachTestLabel() {
        let label = UILabel()
        label.text = "This is a label for testing whether \nthe navigation bar is transparent or not."
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(16)
        label.textColor = UIColor.blueColor()
        label.sizeToFit()
        label.frame.origin = CGPointMake(0, 10)
        label.backgroundColor = UIColor.greenColor()
        RTPrint.shareInstance().prt("[CarMovingViewController:attachTestLabel] frame of testLabel: \(label.frame)")
        self.view.addSubview(label)
    }
}
