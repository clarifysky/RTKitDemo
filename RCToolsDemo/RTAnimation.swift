//
//  RTAnimation.swift
//  RTKit
//
//  Created by Rex Tsao on 9/4/2016.
//  Copyright © 2016 rexcao.net. All rights reserved.
//

import Foundation
import UIKit

class RTAnimation {
    class Transition {

    }
}

enum TransitionAction {
    case Immediately
    case Left
    case Right
    case Up
    case Down
    case FadeIn
    case FadeOut
}

extension UIViewController {
    /// Show one view controller immediately.
    func show(toVC: UIViewController?, fromVC: UIViewController?, completion: ((Bool) -> Void)? ) {
        let finalToFrame: CGRect = UIScreen.mainScreen().bounds
        self.transitionFromViewController(fromVC!, toViewController: toVC!, duration: 0, options: [], animations: {
            toVC!.view.frame = finalToFrame
            }, completion: completion)
    }
    
    /// Swipe a vc according to TransitionAction.
    func swipe(toVC: UIViewController, fromVC: UIViewController, direction: TransitionAction, duration: NSTimeInterval, options: UIViewAnimationOptions, completion: ((Bool) -> Void)?) {
        let screenBounds = UIScreen.mainScreen().bounds
        let finalToFrame = screenBounds
        
        var beginToFrame = CGRectOffset(finalToFrame, screenBounds.size.width, 0)
        var finalFromFrame = CGRectOffset(screenBounds, -screenBounds.size.width / 6, 0)
        switch direction {
        case .Right:
            beginToFrame = CGRectOffset(finalToFrame, -screenBounds.size.width, 0)
            finalFromFrame = CGRectOffset(screenBounds, screenBounds.size.width / 6, 0)
            break
        case .Up:
            beginToFrame = CGRectOffset(finalToFrame, 0, screenBounds.size.height)
            finalFromFrame = CGRectOffset(screenBounds, 0, -screenBounds.size.height / 6)
            break
        case .Down:
            beginToFrame = CGRectOffset(finalToFrame, 0, -screenBounds.size.height)
            finalFromFrame = CGRectOffset(screenBounds, 0, screenBounds.size.height / 6)
            break
        default: break
        }
        self.swiping(toVC, fromVC: fromVC, duration: duration, options: options, completion: completion, beginToFrame: beginToFrame, finalToFrame: finalToFrame, finalFromFrame: finalFromFrame)
    }
    
    /// Swipe a vc according to TransitionAction.
    /// Apple: This method adds the second view controller's view to the view hierarchy and then performs the animations defined in your animations block. After the animation completes, it removes the first view controller's view from the view hierarchy.
    /// IMPORTANT: transitionFromViewController only can be used in the solution which contains a container view controller.
    private func swiping(toVC: UIViewController, fromVC: UIViewController, duration: NSTimeInterval, options: UIViewAnimationOptions, completion: ((Bool) -> Void)?, beginToFrame: CGRect, finalToFrame: CGRect, finalFromFrame: CGRect ) {
        toVC.view.frame = beginToFrame
        self.transitionFromViewController(fromVC, toViewController: toVC, duration: duration, options: options, animations: {
            toVC.view.frame = finalToFrame
            fromVC.view.frame = finalFromFrame
            }, completion: completion)
    }
    
    /// Show a popView in current view controller
    ///
    /// - parameter message: Message to show.
    /// - parameter ticked: Auto removeself or not, set true will remove self automatically, default is true
    func showPop(message: String?, ticked: Bool = true) -> RTView.Pop {
        let popWidth = UIScreen.mainScreen().bounds.width / 2
        let popHeight: CGFloat = 100
        let popOrigin = RTMath.centerOrigin(UIScreen.mainScreen().bounds.size, childSize: CGSizeMake(popWidth, popHeight))
        let popFrame = CGRectMake(popOrigin.x, popOrigin.y, popWidth, popHeight)
        let rcpop = RTView.Pop(frame: popFrame, message: message, ticked: ticked)
        
        self.view.addSubview(rcpop)
        return rcpop
    }
}