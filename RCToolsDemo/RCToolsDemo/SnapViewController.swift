//
//  SnapViewController.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 28/4/2016.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

class SnapViewController: UIViewController {

    private var redView: UIView?
    private var animator: UIDynamicAnimator?
    private var snapBehavior: UISnapBehavior?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SnapViewController.tap(_:)))
        self.view.addGestureRecognizer(tapGesture)
        self.attachRedView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func attachRedView() {
        self.redView = UIView(frame: CGRectMake(100, 100, 200, 100))
        self.redView?.backgroundColor = UIColor.redColor()
        self.view.addSubview(self.redView!)
        
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        self.snapBehavior = UISnapBehavior(item: self.redView!, snapToPoint: self.redView!.center)
        
        self.animator?.addBehavior(self.snapBehavior!)
    }
    
    
    func tap(recognizer: UITapGestureRecognizer) {
        print("tapped")
        if recognizer.state == .Ended {
            if #available(iOS 9.0, *) {
                self.snapBehavior!.snapPoint = recognizer.locationInView(self.view)
            } else {
                
            }
        }
    }

}
