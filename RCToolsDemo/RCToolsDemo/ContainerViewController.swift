//
//  ContainerViewController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 25/9/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var currentVC: UIViewController?
    var firstVC: FirstViewController?
    var secondVC: UIViewController?
    var thirdVC: UIViewController?
    @IBOutlet weak var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.firstVC = UIStoryboard.VCWithSpecificSBAndSBID(SBName: "Main", SBID: "FirstViewController") as? FirstViewController
        self.secondVC = UIStoryboard.VCWithSpecificSBAndSBID(SBName: "Main", SBID: "SecondViewController")
        self.thirdVC = UIStoryboard.VCWithSpecificSBAndSBID(SBName: "Main", SBID: "ThirdViewController")
        
        self.addChildViewController(self.firstVC!)
        self.addChildViewController(self.secondVC!)
        self.addChildViewController(self.thirdVC!)
        
        self.contentView.addSubview(self.thirdVC!.view)
        self.currentVC = self.thirdVC
        
        println("subiews of window: \(RCTools.Window().keyWindow()?.subviews.count)")
        println("subViewControllers of containerViewController: \(self.childViewControllers.count)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClick(sender: UIButton) {
        println("views in container view: \(self.view.subviews.count)")
        
        // When currentVC is presented, the button which used to present the VC can't been clicked.
        if self.currentVC == self.firstVC && sender.tag == 1 {
            return
        }
        
        if self.currentVC == self.secondVC && sender.tag == 2 {
            return
        }
        
        if self.currentVC == self.thirdVC && sender.tag == 3 {
            return
        }
        
        let duration = NSTimeInterval(0.5)
        switch sender.tag {
        case 1:
            self.push(self.firstVC!, fromVC: self.currentVC!, duration: duration, options: UIViewAnimationOptions.CurveEaseInOut, completion: {
                finished in
                if finished {
                    self.currentVC = self.firstVC
                    self.firstVC?.backButton.addTarget(self, action: "toThirdVC", forControlEvents: UIControlEvents.TouchUpInside)
                    println("subViewControllers of containerViewController: \(self.childViewControllers.count)")
                }
            })
            
//            self.push(self.firstVC!, fromVC: self.currentVC!, duration: duration, options: UIViewAnimationOptions.CurveEaseInOut, animations: nil, completion: {
//                finished in
//                if finished {
//                    self.currentVC = self.firstVC
//                }
//            })
            
//            let screenBounds: CGRect = UIScreen.mainScreen().bounds
//            let finalToFrame: CGRect = screenBounds
//            let finalFromFrame: CGRect = CGRectOffset(finalToFrame, -screenBounds.size.width, 0)
//            
//            self.firstVC!.view.frame = CGRectOffset(finalToFrame, screenBounds.size.width, 0)
//            println("views in container view: \(self.view.subviews.count)")
//            
//            // From Apple:
//            // This method adds the second view controller's view to the view hierarchy and then performs the animations defined in your animations block. After the animation completes, it removes the first view controller's view from the view hierarchy.
//            self.transitionFromViewController(self.currentVC!, toViewController: self.firstVC!, duration: duration, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//                    self.firstVC?.view.frame = finalToFrame
//                    self.currentVC?.view.frame = finalFromFrame
//                },
//                completion: {
//                    finished in
//                    if finished {
//                        self.currentVC = self.firstVC!
//                        println("views in container view: \(self.view.subviews.count)")
//                    }
//            })
            break
        case 2:
            self.transitionFromViewController(self.currentVC!, toViewController: self.secondVC!, duration: duration, options: UIViewAnimationOptions.CurveEaseInOut, animations: nil, completion: {
                finished in
                if finished {
                    self.currentVC = self.secondVC!
                }
            })
        case 3:
            self.transitionFromViewController(self.currentVC!, toViewController: self.thirdVC!, duration: duration, options: UIViewAnimationOptions.CurveEaseInOut, animations: nil, completion: {
                finished in
                if finished {
                    self.currentVC = self.thirdVC!
                }
            })
        default: break
        }
    }

    @IBAction func dismissClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func toThirdVC() {
        println("subViewControllers of containerViewController: \(self.childViewControllers.count)")
        let duration = NSTimeInterval(0.5)
//        self.thirdVC = UIStoryboard.VCWithSpecificSBAndSBID(SBName: "Main", SBID: "ThirdViewController")
        self.pushBack(self.thirdVC!, fromVC: self.firstVC, duration: duration, options: UIViewAnimationOptions.CurveEaseInOut, completion: {
            finished in
            if finished {
                self.currentVC = self.thirdVC!
            }
        })
    }
}
