//
//  GravityViewController.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 26/4/2016.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

class GravityViewController: UIViewController {
    
    private var animator: UIDynamicAnimator?
    private var ball: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        // Do any additional setup after loading the view.
        self.ball = UIView(frame: CGRectMake(0, 100, 100, 100))
        self.ball?.layer.cornerRadius = self.ball!.width / 2
        self.ball?.clipsToBounds = true
        self.ball?.backgroundColor = UIColor.greenColor()
        self.view.addSubview(self.ball!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        let gravityBehavior = UIGravityBehavior()
        gravityBehavior.addItem(self.ball!)
        
        let collisionBehavior = UICollisionBehavior()
        collisionBehavior.addItem(self.ball!)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsetsMake(10, 10, 10, 10))
        
        let itemBehavior = UIDynamicItemBehavior()
        itemBehavior.addItem(self.ball!)
        itemBehavior.elasticity = 0.5
        
        self.animator?.addBehavior(gravityBehavior)
        self.animator?.addBehavior(collisionBehavior)
        self.animator?.addBehavior(itemBehavior)
    }

}
