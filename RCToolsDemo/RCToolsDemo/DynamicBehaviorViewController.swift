//
//  FallingLeavesViewController.swift
//  
//
//  Created by Rex Tsao on 1/14/16.
//
//

import UIKit
import pop

class DynamicBehaviorViewController: UIViewController {

    @IBOutlet weak var item: UIView!
    private var animator: UIDynamicAnimator?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "DynamicBehavior"
        
        println("original:")
        self.listenIt()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.final()
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
//        self.caanimationHandle()
        // 3. Decay rotation
//        self.decayRotation()
        // 4. Facebook style rotation
//        self.facebookPop()
        // 5. Final.
//        self.final()
    }
    
    @IBAction func change(sender: UIButton) {
//        self.item.layer.anchorPoint = CGPointMake(0.5, 0)
//        println("after change anchorPoint")
//        self.listenIt()
//        
//        self.item.layer.position = CGPointMake(self.item.layer.position.x, self.item.layer.position.y - self.item.layer.bounds.height * 0.5)
//        println("after change position")
//        self.listenIt()
//        
//        self.facebookPop()
        self.final()
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
    
    private func decayRotation() {
        let anim = CAKeyframeAnimation()
        anim.keyPath = "transform.rotation"
        anim.values = [-5 * CGFloat(M_PI) / 180, 5 * CGFloat(M_PI) / 180, -5 * CGFloat(M_PI) / 180]
        anim.duration = 0.25
        anim.repeatCount = 3.0
        anim.removedOnCompletion = true
        anim.fillMode = kCAFillModeForwards
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        self.item.layer.addAnimation(anim, forKey: "decayrotation")
    }
    
    private func facebookPop() {
        let spin = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
        spin.fromValue = M_PI / 10
        spin.toValue = 0
        spin.springBounciness = 40
        spin.velocity = 20
        spin.removedOnCompletion = true
        
        self.item.layer.pop_addAnimation(spin, forKey: "likeAnimation")
    }
    
    private func final() {
        self.item.layer.anchorPoint = CGPointMake(0.5, 0)
        println("after change anchorPoint")
        self.listenIt()
        
        self.item.layer.position = CGPointMake(self.item.layer.position.x, self.item.layer.position.y - self.item.layer.bounds.height * 0.5)
        println("after change position")
        self.listenIt()
        
        self.facebookPop()
    }
    
    private func listenIt() {
        println("\n")
        println("origin: \(self.item.layer.frame.origin)")
        println("position: \(self.item.layer.position)")
        println("anchor: \(self.item.layer.anchorPoint)")
        println("\n")
    }
}
