//
//  PushViewController.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 29/4/2016.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

class PushViewController: UIViewController {

    private var redView: UIView?
    private var animator: UIDynamicAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.attachRedView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.prepareBehavior()
    }
    
    
    private func attachRedView() {
        self.redView = UIView(frame: CGRectMake(10 ,100, 200, 100))
        self.redView?.backgroundColor = UIColor.redColor()
        self.view.addSubview(self.redView!)
    }
    
    private func prepareBehavior() {
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        let pushBehavior = UIPushBehavior(items: [self.redView!], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.pushDirection = CGVectorMake(1, 0)
        pushBehavior.magnitude = 5
        
        let itemBehavior = UIDynamicItemBehavior()
        itemBehavior.addItem(self.redView!)
        itemBehavior.resistance = 1
        
        self.animator?.addBehavior(pushBehavior)
        self.animator?.addBehavior(itemBehavior)
    }

}
