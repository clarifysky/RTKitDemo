//
//  ChartView.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 24/6/2016.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

class ChartView: UIView {
    
    private var dataGroup: [[CGFloat]] = [[]]
    /// The points after merge, used to draw a long line.
    private var pointsMerged: [CGPoint] = []
    /// The biggest value of one group of data.
    private var maxPoint: CGFloat = 0
    
    private var unitHeight: CGFloat = 0
    private var unitWidth: CGFloat = 0
    static var unitSize = CGSizeZero
    
    init(dataGroup: [[CGFloat]], unitSize: CGSize) {
        let size = CGSizeMake(unitSize.width * CGFloat(dataGroup.count), unitSize.height)
        let frame = CGRect(origin: CGPointZero, size: size)
        super.init(frame: frame)
        self.dataGroup = dataGroup
        ChartView.unitSize = unitSize
        
        self.prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let viewPath = UIBezierPath(rect: rect)
        UIColor.whiteColor().setFill()
        viewPath.fill()
        
        let path = UIBezierPath()
        path.lineWidth = 2.0
        path.lineCapStyle = .Round
        path.moveToPoint(self.pointsMerged[0])
        for i in 1 ..< self.pointsMerged.count {
            let (controlPoint1, controlPoint2) = RTNumber.controlPoint(self.pointsMerged[i - 1], endPoint: self.pointsMerged[i])
            path.addCurveToPoint(self.pointsMerged[i], controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        }
        UIColor.blueColor().setStroke()
        path.stroke()
    }
    
    private func prepare() {
        self.prepareMaxPoint()
        self.prepareMaterials()
    }
    
    
    private func prepareMaxPoint() {
        var maxPoints = [CGFloat]()
        for data in dataGroup {
            maxPoints.append(data.maxElement()!)
        }
        self.maxPoint = maxPoints.maxElement()!
    }
    
    /// Compute the minimum width/height value used for compute the points.
    private func prepareUnits(maxPoint: CGFloat, pointNumber: Int) {
        self.unitWidth = ChartView.unitSize.width * CGFloat(self.dataGroup.count) / CGFloat(pointNumber - 1)
        self.unitHeight = ChartView.unitSize.height / maxPoint
    }
    
    private func prepareMaterials() {
        var dataMerged = [CGFloat]()
        for data in self.dataGroup {
            dataMerged += data
        }
        
        self.prepareUnits(maxPoint, pointNumber: dataMerged.count)
        self.pointsMerged = self.preparePoints(dataMerged)
    }
    
    
    /// Compute all the points on curve line based on units, this is just for one screen.
    private func preparePoints(data: [CGFloat]) -> [CGPoint] {
        var tmp = [CGPoint]()
        for i in 0 ..< data.count {
            tmp.append(CGPointMake(CGFloat(i) * self.unitWidth, data[i] * self.unitHeight))
        }
        return tmp
    }

}
