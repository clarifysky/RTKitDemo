//
//  FallingLeavesViewController.swift
//  
//
//  Created by Rex Tsao on 1/14/16.
//
//

import UIKit

class DynamicBehaviorViewController: UIViewController {

    @IBOutlet weak var item: UIView!
    private var animator: UIDynamicAnimator?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "DynamicBehavior"
//        self.item.transform = CGAffineTransformMakeRotation(CGFloat(45 * CGFloat(M_PI) / 180))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // A complex behavior of one item may contain many behaviors,
        // may include UIAttachmentBehavior（挂接）, UIGravityBehavior（重力）,UICollisionBehavior（碰撞）,
        // UIDynamicItemBehavior（基本行为，这包含一些像空气阻力，摩擦力，弹性密度等等的配置）etc.
        // If you want to create a beautiful behavior for one item, you may create several behavior above
        // for the item one by one first, then create a dynamicBehavior and make behaviors you made in step 1 to
        // be its child, third: create a dynamicAnimator associate with the item, fourth: add dynamicBehavior you
        // created in step 2 to the item.
        
        // 1. Try to use UIDynamicaBehavior to handle this effect.
//        self.behaviorHandle()
        // 2. Try to use CAKeyAnimation to handle this effect.
        self.caanimationHandle()
    }
    
    
    private func behaviorHandle() {
        let behavior = UIDynamicBehavior()

        var anchor = CGPointMake(self.item.frame.origin.x + self.item.frame.width / 2, self.item.frame.origin.y)
        anchor = self.item.frame.origin

        let attachmentBehavior = UIAttachmentBehavior(item: self.item, attachedToAnchor: anchor)
        let gravityBehavior = UIGravityBehavior()
        gravityBehavior.addItem(self.item)
        gravityBehavior.magnitude = 10
        let itemBehavior = UIDynamicItemBehavior()
        itemBehavior.addItem(self.item)
        itemBehavior.allowsRotation = true
        itemBehavior.resistance = 3.0

        behavior.addChildBehavior(attachmentBehavior)
        behavior.addChildBehavior(gravityBehavior)
        behavior.addChildBehavior(itemBehavior)
        
        self.animator = UIDynamicAnimator(referenceView: self.view)
        self.animator!.addBehavior(behavior)
    }
    
    private func caanimationHandle() {
        let anim = CAKeyframeAnimation()
        anim.keyPath = "transform.rotation"
        anim.values = [-5 * CGFloat(M_PI) / 180, 5 * CGFloat(M_PI) / 180, -5 * CGFloat(M_PI) / 180]
        anim.duration = 0.25
        anim.repeatCount = 3.0
        
        anim.removedOnCompletion = true
        anim.fillMode = kCAFillModeForwards
        self.item.layer.addAnimation(anim, forKey: "shake")
    }
    
    private func easeRotation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = -5 * CGFloat(M_PI) / 180
        anim.duration = 0.05
        anim.autoreverses = true
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.item.layer.addAnimation(anim, forKey: "rotation")
    }

}
