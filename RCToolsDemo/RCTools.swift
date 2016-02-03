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
        
        /// Compute the x or y of origin depend on the border-length of (parent view and sub view).
        /// You must ensure that sub view is littler than parent view, then you can use this function.
        ///
        /// :param: borderLengthOfParentView Border length of parent view.
        /// :param: borderLengthOfSelf Border length of sub view.
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
        
        class func pointAtCircle(center: CGPoint, angle: CGFloat, radius: CGFloat) -> CGPoint {
            var x2: CGFloat, y2: CGFloat
            
            x2 = radius * CGFloat(cosf(Float(angle)))
            y2 = radius * CGFloat(sinf(Float(angle)))
            println("angle: \(angle), x2: \(x2), y2: \(y2)")
            x2 = center.x + x2
            y2 = center.y + y2
            
            return CGPointMake(x2, y2)
        }
        
        // appropriate size in specific container
        class func sizeFitContainer(#ContainerSize: CGSize, contentSize: CGSize) -> CGSize {
            var width = contentSize.width
            var height = contentSize.height
            if width > ContainerSize.width {
                width = ContainerSize.width
                height = ContainerSize.width * (contentSize.height / contentSize.width)
                
                if height > ContainerSize.height {
                    height = ContainerSize.height
                    width = (contentSize.width / contentSize.height) * ContainerSize.height
                }
            } else if height > ContainerSize.height {
                height = ContainerSize.height
                width = (contentSize.width / contentSize.height) * ContainerSize.height
                
                if width > ContainerSize.width {
                    width = ContainerSize.width
                    height = ContainerSize.width * (contentSize.height / contentSize.width)
                }
            }
            
            return CGSizeMake(width, height)
        }
    }
    
    // characters
    class Characters {
        class func encodeUrl(url: String) -> String {
            let customAllowedSet = NSCharacterSet(charactersInString: "#%<>@\\^`{|}").invertedSet
            return url.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        }
        
        class func decodeUrl(url: String) -> String {
            return url.stringByRemovingPercentEncoding!
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
    func show(toVC: UIViewController?, fromVC: UIViewController?, completion: ((Bool) -> Void)? ) {
        let screenBounds: CGRect = UIScreen.mainScreen().bounds
        let finalToFrame: CGRect = screenBounds
        let finalFromFrame: CGRect = CGRectOffset(finalToFrame, -screenBounds.size.width, 0)
        self.transitionFromViewController(fromVC!, toViewController: toVC!, duration: 0, options: nil, animations: {
            toVC!.view.frame = finalToFrame
            }, completion: completion)
    }
    
    func swipeLeft(toVC: UIViewController?, fromVC: UIViewController?, duration: NSTimeInterval, options: UIViewAnimationOptions, completion: ((Bool) -> Void)? ) {
        let screenBounds: CGRect = UIScreen.mainScreen().bounds
        let finalToFrame: CGRect = screenBounds
        let finalFromFrame: CGRect = CGRectOffset(finalToFrame, -screenBounds.size.width, 0)
        
        let beginToFrame = CGRectOffset(finalToFrame, screenBounds.size.width, 0)
        self.doAnimation(toVC, fromVC: fromVC, duration: duration, options: options, completion: completion, beginToFrame: beginToFrame, finalToFrame: finalToFrame, finalFromFrame: finalFromFrame)
    }
    
    func swipeRight(toVC: UIViewController?, fromVC: UIViewController?, duration: NSTimeInterval, options: UIViewAnimationOptions, completion: ((Bool) -> Void)? ) {
        let screenBounds: CGRect = UIScreen.mainScreen().bounds
        let finalToFrame: CGRect = screenBounds
        let finalFromFrame: CGRect = CGRectOffset(finalToFrame, screenBounds.size.width, 0)
        
        let beginToFrame = CGRectOffset(finalToFrame, -screenBounds.size.width, 0)
        self.doAnimation(toVC, fromVC: fromVC, duration: duration, options: options, completion: completion, beginToFrame: beginToFrame, finalToFrame: finalToFrame, finalFromFrame: finalFromFrame)
    }
    
    // imitate Apple's presentViewController:
    func swipeUp(toVC: UIViewController?, fromVC: UIViewController?, duration: NSTimeInterval, options: UIViewAnimationOptions, completion: ((Bool) -> Void)? ) {
        let screenBounds: CGRect = UIScreen.mainScreen().bounds
        let finalToFrame: CGRect = screenBounds
        let finalFromFrame: CGRect = CGRectOffset(screenBounds, 0, -screenBounds.size.height)
        
        let beginToFrame = CGRectOffset(screenBounds, 0, screenBounds.size.height)
        self.doAnimation(toVC, fromVC: fromVC, duration: duration, options: options, completion: completion, beginToFrame: beginToFrame, finalToFrame: finalToFrame, finalFromFrame: finalFromFrame)
    }
    
    func swipeDown(toVC: UIViewController?, fromVC: UIViewController?, duration: NSTimeInterval, options: UIViewAnimationOptions, completion: ((Bool) -> Void)?) {
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
    
    func showPop(message: String?) {
        let popWidth = UIScreen.mainScreen().bounds.width / 2
        let popHeight: CGFloat = 100
        let popOrigin = RCTools.Math.originInParentView(sizeOfParentView: UIScreen.mainScreen().bounds.size, sizeOfSelf: CGSizeMake(popWidth, popHeight))
        let popFrame = CGRectMake(popOrigin.x, popOrigin.y, popWidth, popHeight)
        let rcpop = RCPop(frame: popFrame, message: message)
        
        self.view.addSubview(rcpop)
    }
}

extension UIView {
    var animationOptions: UIViewAnimationOptions { return UIViewAnimationOptions.CurveLinear }
    
    func reverseXAnimation(duration: NSTimeInterval, startX: CGFloat, endX: CGFloat) {
        UIView.animateWithDuration(duration, delay: 0, options: self.animationOptions, animations: {
            self.frame.origin.x = endX
            }, completion: {
                finished in
                println("finished")
                if finished {
                    self.reverseXAnimation(duration, startX: endX, endX: startX)
                }
        })
    }
    
    func snapshot() -> UIImage {
        if(UIGraphicsGetCurrentContext() == nil) {
            UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0.0)
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
        }
        self.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    // Add shadow for current view with specified value
    func RCAttachCurveShadow(cornerRadius: CGFloat) {
        	
        let shapeLayer = CALayer()
        shapeLayer.cornerRadius = cornerRadius
        shapeLayer.masksToBounds = true
        
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSizeZero
        self.layer.addSublayer(shapeLayer)
    }
    
    /// Add a curve-shadow effect for current view.
    ///
    /// It will pass parent layer's contens to sub layer, then set parent layer's
    /// contens to nil, then add sub layer to the layer hierachy.
    func RCAddCurveShadowLayer(cornerRadius: CGFloat) {
        let shapeLayer = CALayer()
        shapeLayer.frame = self.layer.bounds
        shapeLayer.cornerRadius = cornerRadius
        shapeLayer.masksToBounds = true
        shapeLayer.contents = self.layer.contents
        
        self.layer.contents = nil
        
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSizeZero
        self.layer.addSublayer(shapeLayer)
    }
    
    func RCCurveShadowSide(alignment: CurveShadowDirection, color: UIColor? = nil, shadowOpacity: Float = 1.0, archHeight: CGFloat = 5) {
        let slayer = CALayer()
        slayer.frame = self.layer.bounds
        slayer.RCCurveShadow(alignment)
        self.layer.addSublayer(slayer)
    }
    
    func attachBadge(size: CGSize = CGSizeMake(25, 25)) {
        let anchorFrame = CGPointMake(self.frame.width - size.width / 2, -size.width / 2)
        let badge = RedCircleLayer()
        badge.frame = CGRect(origin: anchorFrame, size: size)
        self.layer.addSublayer(badge)
    }
    
    func attachBadge(number: Int, size: CGSize = CGSizeMake(25, 25)) {
        if number > 0 {
            let anchorFrame = CGPointMake(self.frame.width - size.width / 2, -size.width / 2)
            let badge = UILabel(frame: CGRect(origin: anchorFrame, size: size))
            badge.textAlignment = .Center
            badge.textColor = UIColor.whiteColor()
            badge.backgroundColor = UIColor.redColor()
            badge.layer.cornerRadius = size.width / 2
            badge.font = UIFont.systemFontOfSize(12)
            badge.text = String(number)
            if number > 999 {
                badge.text = "∙∙∙"
            }
            badge.clipsToBounds = true
            badge.frame = CGRect(origin: anchorFrame, size: size)
            self.addSubview(badge)
        }
    }
}

// Make String in swift can use stringByReplacingCharactersInRange
extension NSRange {
    func toRange(string: String) -> Range<String.Index> {
        let startIndex = advance(string.startIndex, self.location)
        let endIndex = advance(startIndex, self.length)
        return startIndex..<endIndex
    }
}