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
    var secondVC: SecondViewController?
    var thirdVC: ThirdViewController?
    @IBOutlet weak var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.firstVC = UIStoryboard.VCWithSpecificSBAndSBID(SBName: "Main", SBID: "FirstViewController") as? FirstViewController
        self.secondVC = UIStoryboard.VCWithSpecificSBAndSBID(SBName: "Main", SBID: "SecondViewController") as? SecondViewController
        self.thirdVC = UIStoryboard.VCWithSpecificSBAndSBID(SBName: "Main", SBID: "ThirdViewController") as? ThirdViewController
        
        self.addChildViewController(self.firstVC!)
        self.addChildViewController(self.secondVC!)
        self.addChildViewController(self.thirdVC!)
        
        self.contentView.addSubview(self.thirdVC!.view)
        self.thirdVC!.didMoveToParentViewController(self)
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
            self.swipeLeft(self.firstVC!, fromVC: self.currentVC!, duration: duration, options: UIViewAnimationOptions.CurveEaseInOut, completion: {
                finished in
                if finished {
                    self.currentVC = self.firstVC
                    self.firstVC?.backButton.addTarget(self, action: "toThirdVC", forControlEvents: UIControlEvents.TouchUpInside)
                    println("subViewControllers of containerViewController: \(self.childViewControllers.count)")
                }
            })
            
            break
        case 2:
            self.swipeUp(self.secondVC!, fromVC: self.currentVC!, duration: duration, options: UIViewAnimationOptions.CurveEaseInOut, completion: {
                finished in
                if finished {
                    self.currentVC = self.secondVC
                    self.secondVC?.dismissButton.addTarget(self, action: "dismissSecondVC", forControlEvents: UIControlEvents.TouchUpInside)
                    println("subViewControllers of containerViewController: \(self.childViewControllers.count)")
                }
            })
        case 3:
            self.show(self.thirdVC, fromVC: self.currentVC, completion: {
                finished in
                if finished {
                    self.currentVC = self.thirdVC!
                    println("subViewControllers of containerViewController: \(self.childViewControllers.count)")
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
        self.swipeRight(self.thirdVC!, fromVC: self.currentVC!, duration: duration, options: UIViewAnimationOptions.CurveEaseInOut, completion: {
            finished in
            if finished {
                self.currentVC = self.thirdVC!
            }
        })
    }
    
    func dismissSecondVC() {
        println("subViewControllers of containerViewController: \(self.childViewControllers.count)")
        let duration = NSTimeInterval(0.5)
        self.swipeDown(self.thirdVC!, fromVC: self.currentVC!, duration: duration, options: UIViewAnimationOptions.CurveEaseInOut, completion: {
            finished in
            if finished {
                self.currentVC = self.thirdVC!
            }
        })
    }
}