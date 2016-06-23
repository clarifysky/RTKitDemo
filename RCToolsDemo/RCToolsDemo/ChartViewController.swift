//
//  ChartViewController.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 31/5/2016.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {
    
    private var dataGroup: [[CGFloat]] = [
        [5, 4, 10, 22, 16, 14],
        [26, 18, 10, 3, 16, 14],
        [45, 4, 2, 32, 19, 14],
        [30, 21, 14, 28, 8, 3],
        [6, 45, 12, 20, 15, 17],
        [10, 12, 25, 22, 16, 19],
        [19, 16, 10, 18, 65, 48]
    ]
    /// Group made of points, used for represent multiple curve line image.
    private var pointsGroup: [[CGPoint]] = [[CGPoint]]()
    /// Group of bezier path, used for drawing lines on different canvas.
    private var pathsGroup: [UIBezierPath] = [UIBezierPath]()
    /// Group of canvas, used to draw bezier path on it.
//    private var canvasesGroup: [UIView] = [UIView]()
    private var pathLayersGroup: [CAShapeLayer] = [CAShapeLayer]()
    /// The max point across several parts.
    private var maxPoint: CGFloat = 0
    
    
    private var unitHeight: CGFloat = 0
    private var unitWidth: CGFloat = 0
    /// Current index which changes with scrollView's scrolling.
    private var currentIndex: Int = 4
    private static var collectionSize = CGSizeZero
    
    private var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // Disable automatically adjust scroll view insets when use navigationBar.
        self.automaticallyAdjustsScrollViewInsets = false
        ChartViewController.collectionSize = CGSizeMake(self.view.width, 300)
        
        self.prepare()
        self.attachCollection()
        self.scrollToCurrentIndex()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func attachCollection() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = ChartViewController.collectionSize
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .Horizontal
        self.collectionView = UICollectionView(frame: CGRectMake(0, 100, ChartViewController.collectionSize.width, ChartViewController.collectionSize.height), collectionViewLayout: flowLayout)
        self.collectionView?.backgroundColor = UIColor.redColor()
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.registerClass(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        self.view.addSubview(self.collectionView!)
    }
    
    private func prepare() {
        self.prepareMaxPoint()
        self.prepareUnits(maxPoint, pointNumber: 6)
        self.prepareMaterials()
        self.drawPaths()
        
        print("maxPoint: \(self.maxPoint)")
        print("unit: \(self.unitWidth), \(self.unitHeight)")
        print("pointsGroup: \(self.pointsGroup)")
        print("pathsGroup: \(self.pathsGroup)")
        print("layers: \(self.pathLayersGroup)")
//        print("canvasesGroup: \(self.canvasesGroup)")
    }
    
    
    private func prepareMaxPoint() {
        if self.currentIndex == 0 {
            if self.dataGroup.count > 1 {
                // maxPoint
                let tmpArr = [self.dataGroup[0].maxElement()!, self.dataGroup[1].maxElement()!]
                self.maxPoint = tmpArr.maxElement()!
            } else {
                // maxPoint
                self.maxPoint = self.dataGroup[0].maxElement()!
            }
        } else if self.currentIndex == self.dataGroup.count - 1 {
            // As count of dataGroup bigger than zero, count of dataGroup here must bigger than 1,
            // because if the count of dataGroup is 1, it will execute "if self.currentIndex == 0" block
            // first, and will not step into this block.
            
            // maxPoint
            let tmpArr = [self.dataGroup[self.currentIndex - 1].maxElement()!, self.dataGroup[self.currentIndex].maxElement()!]
            self.maxPoint = tmpArr.maxElement()!
        } else {
            // When program step into here, the count of dataGroup must bigger than 2, because if the count is 2 or less,
            // program will step into blocks above first, and this block will not be executed.
            
            // maxPoint
            let tmpArr = [self.dataGroup[self.currentIndex - 1].maxElement()!, self.dataGroup[self.currentIndex].maxElement()!, self.dataGroup[self.currentIndex + 1].maxElement()!]
            self.maxPoint = tmpArr.maxElement()!
        }
    }
    
    private func prepareMaterials() {
        if self.currentIndex == 0 {
            if self.dataGroup.count > 1 {
                // pointsGroup
                pointsGroup.append(self.preparePoints(self.dataGroup[0]))
                pointsGroup.append(self.preparePoints(self.dataGroup[1]))
                
                // paths
                pathsGroup.append(self.preparePath(self.pointsGroup[0][0]))
                pathsGroup.append(self.preparePath(self.pointsGroup[1][0]))
                
                // canvases
//                canvasesGroup.append(self.prepareCanvas())
//                canvasesGroup.append(self.prepareCanvas())
            } else {
                // pointsGroup
                pointsGroup.append(self.preparePoints(self.dataGroup[0]))
                
                // paths
                pathsGroup.append(self.preparePath(self.pointsGroup[0][0]))
                
                // canvases
//                canvasesGroup.append(self.prepareCanvas())
            }
        } else if self.currentIndex == self.dataGroup.count - 1 {
            // As count of dataGroup bigger than zero, count of dataGroup here must bigger than 1,
            // because if the count of dataGroup is 1, it will execute "if self.currentIndex == 0" block
            // first, and will not step into this block.
            
            // pointsGroup
            pointsGroup.append(self.preparePoints(self.dataGroup[self.currentIndex - 1]))
            pointsGroup.append(self.preparePoints(self.dataGroup[self.currentIndex]))
            
            // paths
            pathsGroup.append(self.preparePath(self.pointsGroup[0][0]))
            pathsGroup.append(self.preparePath(self.pointsGroup[1][0]))
            
            // canvases
//            canvasesGroup.append(self.prepareCanvas())
//            canvasesGroup.append(self.prepareCanvas())
        } else {
            // When program step into here, the count of dataGroup must bigger than 2, because if the count is 2 or less,
            // program will step into blocks above first, and this block will not be executed.
            
            // pointsGroup
            pointsGroup.append(self.preparePoints(self.dataGroup[self.currentIndex - 1]))
            pointsGroup.append(self.preparePoints(self.dataGroup[self.currentIndex]))
            pointsGroup.append(self.preparePoints(self.dataGroup[self.currentIndex + 1]))
            
            // paths
            pathsGroup.append(self.preparePath(self.pointsGroup[0][0]))
            pathsGroup.append(self.preparePath(self.pointsGroup[1][0]))
            pathsGroup.append(self.preparePath(self.pointsGroup[2][0]))
            
            // canvases
//            canvasesGroup.append(self.prepareCanvas())
//            canvasesGroup.append(self.prepareCanvas())
//            canvasesGroup.append(self.prepareCanvas())
        }
    }
    
    /// Prepare the canvas for drawing curve line.
    private func prepareCanvas() -> UIView {
        let canvas = UIView(frame: CGRectMake(0, 0, ChartViewController.collectionSize.width, ChartViewController.collectionSize.height))
        canvas.backgroundColor = UIColor.orangeColor()
        return canvas
    }
    
    /// Compute the minimum width/height value used for compute the points.
    private func prepareUnits(maxPoint: CGFloat, pointNumber: CGFloat) {
        self.unitWidth = ChartViewController.collectionSize.width / pointNumber
        self.unitHeight = ChartViewController.collectionSize.height / maxPoint
    }
    
    
    /// Compute all the points on curve line based on units, this is just for one screen.
    private func preparePoints(data: [CGFloat]) -> [CGPoint] {
        var tmp = [CGPoint]()
        for i in 0 ..< data.count {
            tmp.append(CGPointMake(CGFloat(i) * self.unitWidth, data[i] * self.unitHeight))
        }
        return tmp
    }
    
    /// Prepare bezier path for different part of image.
    private func preparePath(firstPoint: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(firstPoint)
        return path
    }
    
    private func substractTail() {
        self.pointsGroup.removeLast()
        self.pathsGroup.removeLast()
//        self.canvasesGroup.removeLast()
        self.pathLayersGroup.removeLast()
    }
    
    private func subtractHead() {
        self.pointsGroup.removeFirst()
        self.pathsGroup.removeFirst()
//        self.canvasesGroup.removeFirst()
        self.pathLayersGroup.removeFirst()
    }
    
    /// Draw paths on canvas
    private func drawPaths() {
        for i in 0..<self.pointsGroup.count {
            self.drawOne(self.pointsGroup[i], path: self.pathsGroup[i])
        }
    }
    
    private func drawOne(points: [CGPoint], path: UIBezierPath) {
        for i in 1 ..< points.count {
            let (controlPoint1, controlPoint2) = RTNumber.controlPoint(points[i - 1], endPoint: points[i])
            path.addCurveToPoint(points[i], controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        }
        let layerPath = CAShapeLayer()
        layerPath.path = path.CGPath
        layerPath.fillColor = nil
        layerPath.strokeColor = UIColor.blueColor().CGColor
        layerPath.lineWidth = 5.0
        layerPath.lineCap = kCALineCapRound
        self.pathLayersGroup.append(layerPath)
//        canvas.layer.addSublayer(layerPath)
    }
    
    
    private func scrollToCurrentIndex() {
        dispatch_async(dispatch_get_main_queue(), {
            var index = 0
            if self.currentIndex == 0 {
            } else if self.currentIndex == self.dataGroup.count - 1 {
                // As count of dataGroup bigger than zero, count of dataGroup here must bigger than 1,
                // because if the count of dataGroup is 1, it will execute "if self.currentIndex == 0" block
                // first, and will not step into this block.
                
                if self.pointsGroup.count == 2 {
                    index = 2
                }
            } else {
                // When program step into here, the count of dataGroup must bigger than 2, because if the count is 2 or less,
                // program will step into blocks above first, and this block will not be executed.
                
                if self.pointsGroup.count == 3 {
                    index = 1
                }
            }
            
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            self.collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: false)
        })
    }

}

extension ChartViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        print(offset)
    }
}

extension ChartViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pointsGroup.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        cell.reAttachLayer(self.pathLayersGroup[indexPath.item])
        return cell
    }
}
