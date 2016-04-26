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
    var fourthVC: UIViewController?
    var fifthVC: FifthViewController?
    var sixNav: UINavigationController?
    
    @IBOutlet weak var contentView: UIView!
    private var currentVCStr: String = "thirdVC"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.firstVC = RTView.viewController("Main", storyboardID: "FirstViewController") as? FirstViewController
        self.secondVC = RTView.viewController("Main", storyboardID: "SecondViewController") as? SecondViewController
        self.thirdVC = RTView.viewController("Main", storyboardID: "ThirdViewController") as? ThirdViewController
        self.fourthVC = RTView.viewController("Main", storyboardID: "FourthNav") as? UINavigationController
        
        let sixVC = SixViewController()
        self.sixNav = UINavigationController(rootViewController: sixVC)
        
        self.addChildViewController(self.firstVC!)
        self.addChildViewController(self.secondVC!)
        self.addChildViewController(self.thirdVC!)
        self.addChildViewController(self.fourthVC!)
        self.addChildViewController(self.sixNav!)
//        self.addChildViewController(self.fifthVC!)
        
        self.contentView.addSubview(self.thirdVC!.view)
        self.thirdVC!.didMoveToParentViewController(self)
        self.currentVC = self.thirdVC
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClick(sender: UIButton) {
        
        // When currentVC is presented, the button which used to present the VC can't been clicked.
        if self.currentVCStr == "firstVC" && sender.tag == 1 {
            return
        }
        
        if self.currentVC == "secondVC" && sender.tag == 2 {
            return
        }
        
        if self.currentVC == "thirdVC" && sender.tag == 3 {
            return
        }
        
        if self.currentVC == "fourthVC" && sender.tag == 4 {
            return
        }
        
        if self.currentVC == "fifthVC" && sender.tag == 5 {
            return
        }
        
        if self.currentVC == "sixNav" && sender.tag == 6 {
            return
        }
        
        let duration = NSTimeInterval(0.5)
        switch sender.tag {
        case 1:
            self.swipe(self.firstVC!, fromVC: self.currentVC!, direction: .Left, duration: duration, options: UIViewAnimationOptions.CurveEaseInOut, completion: {
                finished in
                if finished {
                    self.currentVC = self.firstVC
                    self.currentVCStr = "firstVC"
                    self.firstVC?.backButton.addTarget(self, action: #selector(ContainerViewController.toThirdVC), forControlEvents: UIControlEvents.TouchUpInside)
                    print("subViewControllers of containerViewController: \(self.childViewControllers.count)")
                }
            })
            
            break
        case 2:
            self.swipe(self.secondVC!, fromVC: self.currentVC!, direction: .Up, duration: duration, options: UIViewAnimationOptions.CurveEaseInOut, completion: {
                finished in
                if finished {
                    self.currentVC = self.secondVC
                    self.currentVCStr = "secondVC"
                    self.secondVC?.dismissButton.addTarget(self, action: #selector(ContainerViewController.dismissSecondVC), forControlEvents: UIControlEvents.TouchUpInside)
                    print("subViewControllers of containerViewController: \(self.childViewControllers.count)")
                }
            })
            break
        case 3:
            self.show(self.thirdVC, fromVC: self.currentVC, completion: {
                finished in
                if finished {
                    print("transition from currentVC to thirdVC is finished")
                    self.currentVC = self.thirdVC!
                    self.currentVCStr = "thirdVC"
                    print("subViewControllers of containerViewController: \(self.childViewControllers.count)")
                }
            })
            break
        case 4:
            print("will show fouthVC")
            self.show(self.fourthVC, fromVC: self.currentVC, completion: {
                finished in
                if finished {
                    // Because code below is not executed, so I can't contiue to transit viewControllers.
                    print("transition from currentVC to fourthVC completed")
                    self.currentVC = self.fourthVC!
                    self.currentVCStr = "fourthVC"
                } else {
                    print("transition from currentVC to fourthVC is not finished")
                }
            })
            break
        case 5:
            print("will show fifthVC")
            let fifthVC = RTView.viewController("Main", storyboardID: "FifthViewController") as! FifthViewController
            self.addChildViewController(fifthVC)
            self.show(fifthVC, fromVC: self.currentVC, completion: {
                finished in
                if finished {
                    // Because code below is not executed, so I can't contiue to transit viewControllers.
                    print("transition from currentVC to fifthVC completed")
                    self.currentVC = fifthVC
                    self.currentVCStr = "fifthVC"
                }
            })
            
//            self.show(self.fifthVC, fromVC: self.currentVC, completion: {
//                finished in
//                if finished {
//                    // Because code below is not executed, so I can't contiue to transit viewControllers.
//                    println("transition from currentVC to fifthVC completed")
//                    self.currentVC = self.fifthVC!
//                    self.currentVCStr = "fifthVC"
//                }
//            })
            break
        case 6:
            print("will show six vc")
            self.show(self.sixNav!, fromVC: self.currentVC, completion: {
                finished in
                if finished {
                    // Because code below is not executed, so I can't contiue to transit viewControllers.
                    print("transition from currentVC to sixVC completed")
                    self.currentVC = self.sixNav!
                    self.currentVCStr = "sixNav"
                } else {
                    print("transition from currentVC to sixNav is not finished")
                }
            })
            
        default: break
        }
    }

    @IBAction func dismissClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func toThirdVC() {
        print("subViewControllers of containerViewController: \(self.childViewControllers.count)")
        let duration = NSTimeInterval(0.5)
        self.swipe(self.thirdVC!, fromVC: self.currentVC!, direction: .Right, duration: duration, options: UIViewAnimationOptions.CurveEaseInOut, completion: {
            finished in
            if finished {
                self.currentVC = self.thirdVC!
            }
        })
    }
    
    func dismissSecondVC() {
        print("subViewControllers of containerViewController: \(self.childViewControllers.count)")
        let duration = NSTimeInterval(0.5)
        self.swipe(self.thirdVC!, fromVC: self.currentVC!, direction: .Down, duration: duration, options: UIViewAnimationOptions.CurveEaseInOut, completion: {
            finished in
            if finished {
                self.currentVC = self.thirdVC!
            }
        })
    }
}
