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
    private var attachmentBehavior: UIAttachmentBehavior?
    private var itemBehavior: UIDynamicItemBehavior?
    private var greenView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.buildItem()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(GravityViewController.handleAttachmentGesture(_:)))
        self.view.addGestureRecognizer(panGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        let gravityBehavior = UIGravityBehavior()
        gravityBehavior.addItem(self.greenView!)
        
        let collisionBehavior = UICollisionBehavior()
        collisionBehavior.addItem(self.greenView!)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsetsMake(10, 10, 10, 10))
        
        self.itemBehavior = UIDynamicItemBehavior()
        self.itemBehavior?.addItem(self.greenView!)
        self.itemBehavior?.allowsRotation = true
        self.itemBehavior?.elasticity = 0.5
        
        self.animator?.addBehavior(gravityBehavior)
        self.animator?.addBehavior(collisionBehavior)
        self.animator?.addBehavior(self.itemBehavior!)
    }
    
    
    private func buildItem() {
        self.greenView = UIView(frame: CGRectMake(10, 100, 200, 100))
        self.greenView?.backgroundColor = UIColor.greenColor()
        self.greenView?.transform = CGAffineTransformRotate(self.greenView!.transform, 45)
        self.view.addSubview(self.greenView!)
    }
    
    func handleAttachmentGesture(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .Began {
//            let centerPoint = CGPointMake(self.greenView!.x, self.greenView!.y - 100)
            let centerPoint = CGPointMake(0, self.greenView!.y - 100)
            self.attachmentBehavior = UIAttachmentBehavior(item: self.greenView!, attachedToAnchor: centerPoint)
            self.animator?.addBehavior(self.attachmentBehavior!)
        } else if recognizer.state == .Changed {
            self.attachmentBehavior?.anchorPoint = recognizer.locationInView(self.view)
        } else {
            self.animator?.removeBehavior(self.attachmentBehavior!)
        }
    }

}
