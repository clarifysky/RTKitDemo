//
//  ChartViewController.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 31/5/2016.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {

    private var data: [CGFloat] = [5, 4, 10, 22, 16,14]
    private var points: [CGPoint] = [CGPoint]()
    private var unitHeight: CGFloat = 0
    private var unitWidth: CGFloat = 0
    private var path: UIBezierPath?
    
    private var scrollView: UIScrollView?
    private var canvas: UIView?
    private let layerPath: CAShapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // Disable automatically adjust scroll view insets when use navigationBar.
        self.automaticallyAdjustsScrollViewInsets = false
        self.attachScroll()
        self.prepare()
        self.drawPath()
        
        print(self.scrollView?.contentInset)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func attachScroll() {
        self.scrollView = UIScrollView(frame: CGRectMake(0, 100, self.view.width, 300))
        self.scrollView?.backgroundColor = UIColor.colorBigRGB(126, green: 221, blue: 33)
        self.scrollView?.contentOffset = CGPointZero
        self.scrollView?.contentInset = UIEdgeInsetsZero
        self.scrollView?.contentSize = CGSizeMake(self.view.width, 300)
        self.view.addSubview(self.scrollView!)
    }
    
    private func prepare() {
        self.prepareCanvas()
        self.prepareUnits()
        self.preparePoints()
        self.initializePath()
    }
    
    /// Prepare the canvas for drawing curve line.
    private func prepareCanvas() {
        self.canvas = UIView(frame: CGRectMake(0, 0, self.view.width, 300))
        self.canvas?.backgroundColor = UIColor.purpleColor()
        print("frame of canvas: \(self.canvas!.frame)")
        self.scrollView?.addSubview(self.canvas!)
    }
    
    /// Compute the minimum width/height value used for compute the points.
    private func prepareUnits() {
        self.unitWidth = self.canvas!.width / CGFloat(self.data.count)
        self.unitHeight = self.canvas!.height / self.data.maxElement()!
        
        print("unitWidth: \(unitWidth), unitHeight: \(unitHeight)")
    }
    
    /// Compute all the points on curve line based on units.
    private func preparePoints() {
        for i in 0 ..< self.data.count {
            self.points.append(CGPointMake(CGFloat(i) * self.unitWidth, self.data[i] * self.unitHeight))
        }
    }
    
    private func initializePath() {
        self.path = UIBezierPath()
        self.path?.moveToPoint(self.points[0])
    }
    
    private func drawPath() {
        for i in 1 ..< self.data.count {
            let (controlPoint1, controlPoint2) = RTNumber.controlPoint(self.points[i - 1], endPoint: self.points[i])
            self.path?.addCurveToPoint(self.points[i], controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        }
        self.layerPath.path = self.path!.CGPath
        self.layerPath.fillColor = nil
        self.layerPath.strokeColor = UIColor.blueColor().CGColor
        self.layerPath.lineWidth = 5.0
        self.layerPath.lineCap = kCALineCapRound
        self.canvas?.layer.addSublayer(self.layerPath)
    }

}
