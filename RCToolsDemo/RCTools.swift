//
//  RCTools.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 17/9/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import Foundation
import UIKit

class RCTools {
    
    // computation with math
    class Math {
        
        // compute the x or y of origin depend on the border-length of (parent view and sub view)
        class func xyInParentBorder(#borderLengthOfParentView: CGFloat, borderLengthOfSelf: CGFloat) -> CGFloat {
            return (borderLengthOfParentView - borderLengthOfSelf) / 2
        }
        
        // compute the origin of subview in parentview depend on the size of parentview and subview
        class func originInParentView(#sizeOfParentView: CGSize, sizeOfSelf: CGSize) -> CGPoint {
            let x = self.xyInParentBorder(borderLengthOfParentView: sizeOfParentView.width, borderLengthOfSelf: sizeOfSelf.width)
            let y = self.xyInParentBorder(borderLengthOfParentView: sizeOfParentView.height, borderLengthOfSelf: sizeOfSelf.height)
            return CGPointMake(x, y)
        }
        
        class func sizeInParentByInsets(#sizeOfParentView: CGSize, insetsOfParentView: UIEdgeInsets) -> CGSize {
            let width = sizeOfParentView.width - insetsOfParentView.left - insetsOfParentView.right
            let height = sizeOfParentView.height - insetsOfParentView.top - insetsOfParentView.bottom
            return CGSizeMake(width, height)
        }
    }
    
    // window tools
    class Window {
        var maskColor: UIColor? = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
        
        // This window used to handle all the mask.
        // You must specify a VC(UIViewController) for rootViewController of this window.
        // Every view you used for mask should be add to this window's rootViewController's view
        var sharedWindow: UIWindow?
        
        // MARK: The instance of this class should only have one in the life cycle of one app.
        init() {
//            self.createWindow()
        }
        
        func keyWindow() -> UIWindow? {
            return UIApplication.sharedApplication().keyWindow
        }
        
        func createWindow() {
            if self.sharedWindow == nil {
                self.sharedWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
                self.sharedWindow?.windowLevel = UIWindowLevelAlert
                self.sharedWindow?.hidden = false
                // This makes background of window is transparent
                self.sharedWindow?.backgroundColor = UIColor.clearColor()
                // You should create a UIViewController in storyboard for the rootViewController of this window
                // Change the viewController in storyboard to yours.
                let popVC = UIStoryboard.VCWithSpecificSBAndSBID(SBName: "Main", SBID: "MaskViewController") as! MaskViewController
                popVC.view.backgroundColor = self.maskColor
                popVC.windowTools = self
                self.sharedWindow?.rootViewController = popVC
            }
        }
        
        // All the mask
        func mask() {
            self.createWindow()
            println(":RCTools: views before mask: \(self.sharedWindow!.rootViewController?.view.subviews.count)")
            self.sharedWindow?.windowLevel = UIWindowLevelAlert
            
            println(":RCTools: views after mask: \(self.sharedWindow!.rootViewController?.view.subviews.count)")
        }
        
        /**
        * view: The view you want to remove
        */
        func revokeMask(view: UIView?) {
            println(":RCTools: views before remove: \(self.sharedWindow!.rootViewController?.view.subviews.count)")
            if let removeView = view {
                removeView.removeFromSuperview()
            }
            println(":RCTools: views after remove: \(self.sharedWindow!.rootViewController?.view.subviews.count)")
            
            // MARK: Why a empty havs two views?
            if self.sharedWindow!.rootViewController?.view.subviews.count == 2 {
                // There is no any view for mask, revoke the window
                self.sharedWindow?.windowLevel = UIWindowLevelNormal - 1
                self.sharedWindow = nil
            }
            
        }
    }
}

// Storyboard
extension UIStoryboard {
    class func VCWithSpecificSBAndSBID(#SBName: String, SBID: String) -> UIViewController {
        return UIStoryboard(name: SBName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(SBID) as! UIViewController
    }
    
    class func NWithSpecificSBAndSBID(#SBName: String, SBID: String) -> UINavigationController {
        return UIStoryboard(name: SBName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(SBID) as! UINavigationController
    }
}

// UIViewController
extension UIViewController {
    func push(toVC: UIViewController?, fromVC: UIViewController?, duration: NSTimeInterval, options: UIViewAnimationOptions, completion: ((Bool) -> Void)? ) {
        let screenBounds: CGRect = UIScreen.mainScreen().bounds
        let finalToFrame: CGRect = screenBounds
        let finalFromFrame: CGRect = CGRectOffset(finalToFrame, -screenBounds.size.width, 0)
        
        let beginToFrame = CGRectOffset(finalToFrame, screenBounds.size.width, 0)
        self.doAnimation(toVC, fromVC: fromVC, duration: duration, options: options, completion: completion, beginToFrame: beginToFrame, finalToFrame: finalToFrame, finalFromFrame: finalFromFrame)
    }
    
    func pushBack(toVC: UIViewController?, fromVC: UIViewController?, duration: NSTimeInterval, options: UIViewAnimationOptions, completion: ((Bool) -> Void)? ) {
        let screenBounds: CGRect = UIScreen.mainScreen().bounds
        let finalToFrame: CGRect = screenBounds
        let finalFromFrame: CGRect = CGRectOffset(finalToFrame, screenBounds.size.width, 0)
        
        let beginToFrame = CGRectOffset(finalToFrame, -screenBounds.size.width, 0)
        self.doAnimation(toVC, fromVC: fromVC, duration: duration, options: options, completion: completion, beginToFrame: beginToFrame, finalToFrame: finalToFrame, finalFromFrame: finalFromFrame)
    }
    
    // imitate Apple's presentViewController:
    func modal(toVC: UIViewController?, fromVC: UIViewController?, duration: NSTimeInterval, options: UIViewAnimationOptions, completion: ((Bool) -> Void)? ) {
        let screenBounds: CGRect = UIScreen.mainScreen().bounds
        let finalToFrame: CGRect = screenBounds
        let finalFromFrame: CGRect = CGRectOffset(screenBounds, 0, -screenBounds.size.height)
        
        let beginToFrame = CGRectOffset(screenBounds, 0, screenBounds.size.height)
        self.doAnimation(toVC, fromVC: fromVC, duration: duration, options: options, completion: completion, beginToFrame: beginToFrame, finalToFrame: finalToFrame, finalFromFrame: finalFromFrame)
    }
    
    func modalDismiss(toVC: UIViewController?, fromVC: UIViewController?, duration: NSTimeInterval, options: UIViewAnimationOptions, completion: ((Bool) -> Void)?) {
        let screenBounds: CGRect = UIScreen.mainScreen().bounds
        let finalToFrame: CGRect = screenBounds
        let finalFromFrame: CGRect = CGRectOffset(screenBounds, 0, screenBounds.size.height)
        
        let beginToFrame = CGRectOffset(screenBounds, 0, -screenBounds.size.height)
        self.doAnimation(toVC, fromVC: fromVC, duration: duration, options: options, completion: completion, beginToFrame: beginToFrame, finalToFrame: finalToFrame, finalFromFrame: finalFromFrame)
    }
    
    // From Apple:
    // This method adds the second view controller's view to the view hierarchy and then performs the animations defined in your animations block. After the animation completes, it removes the first view controller's view from the view hierarchy.
    private func doAnimation(toVC: UIViewController?, fromVC: UIViewController?, duration: NSTimeInterval, options: UIViewAnimationOptions, completion: ((Bool) -> Void)?, beginToFrame: CGRect?, finalToFrame: CGRect?, finalFromFrame: CGRect? ) {
        toVC?.view.frame = beginToFrame!
        self.transitionFromViewController(fromVC!, toViewController: toVC!, duration: duration, options: options, animations: {
            toVC!.view.frame = finalToFrame!
            fromVC!.view.frame = finalFromFrame!
        }, completion: completion)
    }
}