//
//  SegueTools.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 30/9/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class SegueTools {
    var fromVC: UIViewController?
    var toVC: UIViewController?
    
    func push(containerVC: UIViewController? ,fromVC: UIViewController?, toVC: UIViewController?) {
        let screenBounds: CGRect = UIScreen.mainScreen().bounds
        
        let finalToFrame: CGRect = screenBounds
        let finalFromFrame: CGRect = CGRectOffset(finalToFrame, -screenBounds.size.width, 0)
        
        toVC!.view.frame = CGRectOffset(finalToFrame, screenBounds.size.width, 0)
        containerVC!.view.addSubview(toVC!.view)
        
        toVC!.view.frame = finalToFrame
        fromVC!.view.frame = finalFromFrame
    }
}
