//
//  CarMovingViewController.swift
//  RCToolsDemo
//
//  Created by Apple on 10/28/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class CarMovingViewController: UIViewController {

    private var car: UIView?
    private var movingAnimation: CABasicAnimation?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.car = self.buildCar()
        self.view.addSubview(self.car!)
        
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
    
    func buildCar() -> UIView {
        let car = UIView(frame: CGRectMake(10, 64, 40, 40))
        car.backgroundColor = UIColor.blueColor()
        return car
    }
    
    func stopCar() {
        
    }
}
