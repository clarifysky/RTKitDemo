//
//  RTView.swift
//  RTKit
//
//  Created by Rex Tsao on 9/4/2016.
//  Copyright © 2016 rexcao.net. All rights reserved.
//

import Foundation
import WebKit

class RTView {
    
    class func viewController(storyboardName: String, storyboardID: String) -> UIViewController {
        return UIStoryboard(name: storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(storyboardID)
    }
    
    class Pop: UIView {
        
        lazy var messageLabel = UILabel()
        private var timer: NSTimer?
        var ticking: Bool = true {
            willSet {
                self.whetherTick(newValue)
            }
        }
        
        init(frame: CGRect, message: String?, ticked: Bool = true) {
            super.init(frame: frame)
            self.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
            self.layer.cornerRadius = 10
            
            self.messageLabel.numberOfLines = 0
            self.messageLabel.text = message
            self.messageLabel.textColor = UIColor.whiteColor()
            self.messageLabel.textAlignment = .Center
            self.messageLabel.backgroundColor = UIColor.clearColor()
            let properSize = self.messageLabel.sizeThatFits(CGSizeMake(3 * frame.width / 4, frame.height))
            
            let labelOrigin = RTMath.centerOrigin(frame.size, childSize: properSize)
            self.messageLabel.frame = CGRectMake(labelOrigin.x, labelOrigin.y, properSize.width, properSize.height)
            self.addSubview(self.messageLabel)
            
            self.whetherTick(ticked)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func whetherTick(ticked: Bool) {
            if ticked {
                self.timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1), target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
            } else {
                self.timer?.invalidate()
                self.timer = nil
            }
        }
        
        func tick() {
            self.timer?.invalidate()
            self.removeFromSuperview()
        }
    }
}

/// Used to identify where the badge will show.
enum BadgePosition {
    case TopLeft
    case TopMiddle
    case TopRight
    case LeftMiddle
    case BottomLeft
    case BottomMiddle
    case BottomRight
    case RightMiddle
}

extension UIView {
    /// Take a snapshot of current view.
    func snapshot() -> UIImage? {
        if(UIGraphicsGetCurrentContext() == nil) {
            UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0.0)
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
        }
        
        // For UIView, use this way to capture its content as UIImage.
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// Add a curve-shadow effect for current view.
    ///
    /// It will pass parent layer's contens to sub layer, then set parent layer's
    /// contens to nil, then add sub layer to the layer hierachy.
    func curveShadow(cornerRadius: CGFloat) {
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
    
    /// Attach a red dot on the view. You may specify the number which will be shown in the red dot.
    ///
    /// - parameter number: The number which will be show in the red dot. 0 means nothing will be shown, 
    ///   in this case, the badge may be a very small dot.
    /// - parameter position: The position of badge.
    func badge(number: Int = 0, position: BadgePosition = .TopRight) -> UILabel {
        var size = CGSizeMake(10, 10)
        var text = String(number)
        
        if number == 0 {
            text = ""
        } else if number > 999 {
            text = "***"
        }
        
        let badge = UILabel()
        badge.textAlignment = .Center
        badge.textColor = UIColor.whiteColor()
        badge.backgroundColor = UIColor.redColor()
        badge.font = UIFont.systemFontOfSize(12)
        badge.text = text
        badge.sizeToFit()
        if badge.frame.size != CGSizeZero {
            size = badge.frame.size
        }
        
        var anchor = CGPoint()
        switch position {
        case .TopRight:
            anchor = CGPointMake(self.frame.width - size.width / 2, -size.height / 2)
            break
        case .TopLeft:
            anchor = CGPointMake(-size.width / 2, -size.height / 2)
            break
        case .TopMiddle:
            let x = RTMath.centerPos(self.frame.width, length: badge.frame.width)
            anchor = CGPointMake(x, -size.height / 2)
            break
        case .LeftMiddle:
            let y = RTMath.centerPos(self.frame.height, length: badge.frame.height)
            anchor = CGPointMake(-size.width / 2, y)
            break
        case .BottomLeft:
            anchor = CGPointMake(-size.width / 2, self.frame.height + badge.frame.height / 2)
            break
        case .BottomMiddle:
            let x = RTMath.centerPos(self.frame.width, length: size.width)
            anchor = CGPointMake(x, self.frame.height + badge.frame.height / 2)
            break
        case .BottomRight:
            anchor = CGPointMake(self.frame.width + badge.frame.width / 2, self.frame.height + badge.frame.height / 2)
            break
        case .RightMiddle:
            let y = RTMath.centerPos(self.frame.height, length: size.height)
            anchor =  CGPointMake(self.frame.width + badge.frame.width / 2, y)
            break
        }
        
        badge.frame = CGRect(origin: anchor, size: size)
        badge.layer.cornerRadius = size.height / 2
        badge.clipsToBounds = true
        self.addSubview(badge)
        return badge
    }
    
    
    /// Set the border for specific view.
    func setBorder(borderColor: CGColor, borderWidth: CGFloat) {
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
    }
    
    /// Width of current view's frame.
    var width: CGFloat {
        return self.frame.width
    }
    
    /// Height of current view's frame.
    var height: CGFloat {
        return self.frame.height
    }
    
    /// Origin of current view based on its superView.
    var origin: CGPoint {
        return self.frame.origin
    }
    
    /// Value of x axis of current view based on its superView.
    var x: CGFloat {
        return self.origin.x
    }
    
    /// Value of x axis of current view's right edge.
    var xRight: CGFloat {
        return self.x + self.width
    }
    
    /// Value of y axis of current view based on its superView.
    var y: CGFloat {
        return self.origin.y
    }
    
    /// Value of y axis of current view's bottom edge.
    var yBottom: CGFloat {
        return self.y + self.height
    }
    
    /// Set value of x axis of current view based on its superView.
    func setX(x: CGFloat) {
        self.frame.origin = CGPointMake(x, self.origin.y)
    }
    
    /// Set value of y axis of current view based on its superView.
    func setY(y: CGFloat) {
        self.frame.origin = CGPointMake(self.origin.x, y)
    }
    
    /// Set origin for current view based on its superView.
    func setOrigin(origin: CGPoint) {
        self.frame.origin = origin
    }
    
    func setOrigin(x: CGFloat, y: CGFloat) {
        self.setOrigin(CGPointMake(x, y))
    }
    
    /// Set width for current view.
    func setWidth(width: CGFloat) {
        self.frame = CGRectMake(self.x, self.y, width, self.height)
    }
    
    /// Set height for current view.
    func setHeight(height: CGFloat) {
        self.frame = CGRectMake(self.x, self.y, self.width, height)
    }
    
    /// Set size for current view.
    func setSize(size: CGSize) {
        self.frame = CGRect(origin: self.origin, size: size)
    }
    
    /// Attach border view to current view, this type of border is the border which will add to current view, it's not
    /// the way to add border on layer. This may add four view which their tag which sorted with top, left, bottom, right
    /// is 100, 101, 102, 103  to current view.
    ///
    /// - parameter RTBorders: The array of RTBorder instances, this instances include information of border, like side,
    /// borderWidth, borderColor etc.
    func attachBorder(RTBorders: [RTBorder]) {
        for rtBorder in RTBorders {
            var borderFrame = CGRectMake(0, 0, self.width, rtBorder.borderWidth)
            var borderViewTag = 100
            switch rtBorder.side {
            case .Top:
                // This is the default one, do nothing.
                break
            case .Left:
                borderFrame = CGRectMake(0, 0, rtBorder.borderWidth, self.height)
                borderViewTag = 101
                break
            case .Bottom:
                borderFrame = CGRectMake(0, self.height - rtBorder.borderWidth, self.width, rtBorder.borderWidth)
                borderViewTag = 102
                break
            case .Right:
                borderFrame = CGRectMake(self.width - rtBorder.borderWidth, 0, rtBorder.borderWidth, self.height)
                borderViewTag = 103
            }
            
            let borderView = UIView(frame: borderFrame)
            borderView.backgroundColor = rtBorder.borderColor
            borderView.tag = borderViewTag
            self.addSubview(borderView)
        }
    }
    
    /// Rmove all attached border view depends on these views' tag
    func removeAttachedBorder() {
        for subview in self.subviews {
            if [100, 101, 102, 103].contains(subview.tag) {
                subview.removeFromSuperview()
            }
        }
    }
    
    /// Judge whether this view has been added border view or not. This property use closure to 
    /// get the result.
    var attachedBorder: Bool {
        return {
            () -> Bool in
            var result = false
            for subview in self.subviews {
                if [100, 101, 102, 103].contains(subview.tag) {
                    result = true
                    break
                }
            }
            return result
        }()
        // The () here means {}(), it means immediately called the closure while it has been built.
    }
}

extension UILabel {
    
    func boldFont() {
        let currentFont = self.font
        let newFont = UIFont(name: currentFont.fontName + "-Bold", size: currentFont.pointSize)
        self.font = newFont
    }
}

extension WKWebView {
    /// Take a snapshot of current WKWebView.
    override func snapshot() -> UIImage? {
        if(UIGraphicsGetCurrentContext() == nil) {
            UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0.0)
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
        }
        
        // For webView, use this way to capture its content as UIImage.
        for subView in self.subviews {
            (subView ).drawViewHierarchyInRect((subView ).bounds, afterScreenUpdates: true)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage{
    /// Get new UIImage which alpha value as you specified.
    func alpha(value: CGFloat) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        let ctx = UIGraphicsGetCurrentContext();
        let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height);
        
        CGContextScaleCTM(ctx, 1, -1);
        CGContextTranslateCTM(ctx, 0, -area.size.height);
        CGContextSetBlendMode(ctx, CGBlendMode.Multiply);
        CGContextSetAlpha(ctx, value);
        CGContextDrawImage(ctx, area, self.CGImage);
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    
    /// Scale image.
    func scale(newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
}

enum CurveShadowSide {
    case Top
    case Left
    case Bottom
    case Right
}

extension CALayer {
    /// Add a curve shadow to specific layer according to the side you specified.
    /// If you want to show shadow on both left and right side, or more, you could use more than one layer to achieve this goal.
    func curveShadow(side: CurveShadowSide, color: UIColor? = nil, shadowOpacity: Float = 1.0, archHeight: CGFloat = 5) {
        var startPoint: CGPoint,  endPoint: CGPoint, controlPoint: CGPoint, shadowOffset: CGSize
        switch side {
        case .Top:
            startPoint = CGPointMake(0, 0)
            endPoint = CGPointMake(self.frame.width, 0)
            controlPoint = CGPointMake(self.frame.width / 2, -archHeight)
            break
        case .Left:
            startPoint = CGPointMake(0, self.frame.height)
            endPoint = CGPointMake(0, 0)
            controlPoint = CGPointMake(-archHeight, self.frame.height / 2)
            break
        case .Bottom:
            startPoint = CGPointMake(0, self.frame.height)
            endPoint = CGPointMake(self.frame.width, self.frame.height)
            controlPoint = CGPointMake(self.frame.width / 2, self.frame.height + archHeight)
            break
        case .Right:
            startPoint = CGPointMake(self.frame.width, self.frame.height)
            endPoint = CGPointMake(self.frame.width, 0)
            controlPoint = CGPointMake(self.frame.width + archHeight, self.frame.height / 2)
            break
        }
        
        let path = UIBezierPath()
        path.moveToPoint(startPoint)
        path.addQuadCurveToPoint(endPoint, controlPoint: controlPoint)
        
        shadowOffset = CGSizeZero
        self.shadowOpacity = shadowOpacity
        self.shadowOffset = shadowOffset
        if color != nil {
            self.shadowColor = color!.CGColor
        }
        
        self.shadowPath = path.CGPath
    }
}

extension UINavigationBar {
    
    /// Make navigation bar to be complete transparent.
    func totalTransparent() {
        self.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.shadowImage = UIImage()
    }
    
    /// Set a transparent color to navigation bar.
    func transparentBgColor(backgroundColor: UIColor?) {
        self.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.shadowImage = UIImage()
        self.backgroundColor = backgroundColor
    }
    
    /// Set an opaque color to navigation bar.
    func opaqueBgColor(backgroundColor: UIColor) {
        self.translucent = false
        self.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.shadowImage = UIImage()
        self.barTintColor = backgroundColor
    }
    
    /// Use this private struct to store the extended properties. This will not pollute the namespace.
    private struct AssociatedKeys {
        static var Overlay: UIView?
    }
    
    /// Use this extended property to prepare for add a custome view to navigationBar
    var overlay: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.Overlay) as? UIView
        }
        set {
            if newValue != nil {
                objc_setAssociatedObject(self, &AssociatedKeys.Overlay, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    /// Set backgroundColor for UINavigationBar
    func RTBackgroundColor(color: UIColor) {
        if self.overlay == nil {
            self.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            self.overlay = UIView(frame: CGRectMake(0, -RTNumber.statusBarHeight(), UIScreen.mainScreen().bounds.width, self.bounds.height + RTNumber.statusBarHeight()))
            self.overlay?.userInteractionEnabled = false
            self.insertSubview(self.overlay!, atIndex: 0)
        }
        self.overlay?.backgroundColor = color
    }
    
    func RTReset() {
        self.setBackgroundImage(nil, forBarMetrics: .Default)
        self.overlay?.removeFromSuperview()
        self.overlay = nil
    }
}

extension UIColor {
    
    class func colorWithRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    class func colorWithRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// Get the uiimage as you specified color.
    class func imageWithColor(color :UIColor) -> UIImage {
        let rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    class func colorWithRGBHex(hex: Int, alpha: Float = 1.0) -> UIColor {
        let r = Float((hex >> 16) & 0xFF)
        let g = Float((hex >> 8) & 0xFF)
        let b = Float((hex) & 0xFF)
        
        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue:CGFloat(b / 255.0), alpha: CGFloat(alpha))
    }
}


extension NSLayoutConstraint {
    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)"
    }
}