//
//  AttachmentViewController.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 27/4/2016.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

class AttachmentViewController: UIViewController {

    private var animator: UIDynamicAnimator?
    private var redView: UIView?
    private var anchorView: UIView?
    
    private var anchorPoint: CGPoint?
    private var attachmentBehavior: UIAttachmentBehavior?
    private var gravityBehavior: UIGravityBehavior?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        // gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AttachmentViewController.hold(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        self.attachAnchor()
        self.attachRedView()
        self.prepareBehavior()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func attachAnchor() {
        self.anchorView = UIView(frame: CGRectMake(200, 65, 10, 10))
        self.anchorView?.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.anchorView!)
        self.anchorPoint = self.anchorView?.origin
    }
    
    
    private func attachRedView() {
        let redView = UIView(frame: CGRectMake(100, 100, 100, 50))
        redView.backgroundColor = UIColor.redColor()
        self.redView = redView
        self.view.addSubview(self.redView!)
    }
    
    
    private func prepareBehavior() {
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        self.attachmentBehavior = UIAttachmentBehavior(item: self.redView!, attachedToAnchor: self.anchorPoint!)
        self.attachmentBehavior?.length = 100   
        self.attachmentBehavior?.frequency = 5
        self.attachmentBehavior?.damping = 2
        self.animator?.addBehavior(self.attachmentBehavior!)
        
        self.gravityBehavior = UIGravityBehavior()
        self.gravityBehavior?.addItem(self.redView!)
        self.animator?.addBehavior(self.gravityBehavior!)
        
        let itemBehavior = UIDynamicItemBehavior()
        itemBehavior.addItem(self.redView!)
        itemBehavior.allowsRotation = true
        self.animator?.addBehavior(itemBehavior)
    }
    
    func hold(recognizer: UITapGestureRecognizer) {
        let anchorPoint = recognizer.locationInView(self.view)
        self.attachmentBehavior?.anchorPoint = anchorPoint
        self.anchorView?.setOrigin(anchorPoint)
    }

}
