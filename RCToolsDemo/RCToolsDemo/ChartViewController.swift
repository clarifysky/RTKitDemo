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
//    private var offsetX: CGFloat = 0 {
//        willSet {
//            if !self.automaticSwitch {
//                // decrease part
//                if self.currentScreenIndex > 0 {
//                    if newValue < self.offsetX || newValue == 0 {
//                        self.currentScreenIndex -= 1
//                        // Trigger redraw curve line here.
//                        self.redrawChart()
//                    }
//                }
//                // increase part
//                if self.currentScreenIndex < self.dataGroup.count - 1 {
//                    // X of contentOffset is at most the whole width of one screen.
//                    if newValue > self.offsetX || newValue == self.scrollView!.width {
//                        self.currentScreenIndex += 1
//                        // Trigger redraw curve line here.
//                        self.redrawChart()
//                    }
//                }
//            }
//            print("current index: \(self.currentScreenIndex)")
//            print(">>>>>>>>offsetX at endDicelerating: \(self.offsetX)>>>>>>>\n")
//        }
//    }
    /// Used to indicate that whether the scrollView is scrolled automatically or via program.
    /// If the scrollView scrolls conform to program, this does not means that you should decrease/increse
    /// the currentScreenIndex, otherwise, you should adjust the currentScreenIndex.
//    private var automaticSwitch: Bool = false
    /// Current index of screen.
    private var currentScreenIndex: Int = 6
    /// X of contentOffset at when scrollViewBeginDragging.
    private var beginOffsetX: CGFloat = 0
    /// X of contentOffset at when scrollViewDidDecelerating.
    private var endOffsetX: CGFloat = 0
    
    private var scrollView: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // Disable automatically adjust scroll view insets when use navigationBar.
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.attachScroll()
        
        // Set the default offsetX
//        self.directSetOffsetX(self.view.width)
//        self.scrollToSpecificIndex(1)
        self.beginOffsetX = self.view.width
        self.endOffsetX = self.view.width
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func attachScroll() {
        self.scrollView = UIScrollView(frame: CGRectMake(0, 100, self.view.width, 300))
        self.scrollView?.delegate = self
        self.scrollView?.pagingEnabled = true
        self.view.addSubview(scrollView!)
        
        let pluckedData = self.pluckData()
        let chartView = ChartView( dataGroup: pluckedData, unitSize: CGSizeMake(self.scrollView!.width, self.scrollView!.height))
        self.scrollView?.contentSize = chartView.frame.size
        self.scrollToSpecificIndex(1)
        self.scrollView?.addSubview(chartView)
        
        print("-count of pluckedData: \(pluckedData.count)")
    }
    
    private func pluckData() -> [[CGFloat]] {
        var tmp = [[CGFloat]]()
        if self.dataGroup.count > 0 {
            if self.currentScreenIndex == 0 {
                if self.dataGroup.count > 1 {
                    tmp.append(self.dataGroup[0])
                    tmp.append(self.dataGroup[1])
                } else {
                    tmp.append(self.dataGroup[0])
                }
            } else if self.currentScreenIndex == self.dataGroup.count - 1 {
                if self.dataGroup.count > 1 {
                    tmp.append(self.dataGroup[self.currentScreenIndex - 1])
                    tmp.append(self.dataGroup[self.currentScreenIndex])
                }
            } else {
                tmp.append(self.dataGroup[self.currentScreenIndex - 1])
                tmp.append(self.dataGroup[self.currentScreenIndex])
                tmp.append(self.dataGroup[self.currentScreenIndex + 1])
            }
        }
        return tmp
    }
    
    
    private func scrollToSpecificIndex(index: Int) {
        print("-scroll to index: \(index)")
//        dispatch_async(dispatch_get_main_queue(), {
        
//            self.scrollView?.scrollRectToVisible(CGRectMake(CGFloat(index) * self.scrollView!.width, 0, self.scrollView!.width, self.scrollView!.height), animated: false)
//        })
        
        self.scrollView?.contentOffset = CGPointMake(CGFloat(index) * self.scrollView!.width, 0)
    }
    
    private func getIndexOfScroll() -> Int {
        var currentScrollIndex = 0
        if self.dataGroup.count > 0 {
            if self.currentScreenIndex == 0 {
                currentScrollIndex = 0
            } else if self.currentScreenIndex == self.dataGroup.count - 1 {
                currentScrollIndex = 1
            } else {
                currentScrollIndex = 1
            }
        }
        return currentScrollIndex
    }
    
    private func redrawChart() {
        for view in self.scrollView!.subviews {
            view.removeFromSuperview()
        }
        
        let pluckedData = self.pluckData()
        let chartView = ChartView(dataGroup: pluckedData, unitSize: CGSizeMake(self.scrollView!.width, self.scrollView!.height))
        chartView.layer.opacity = 0.0
        self.scrollView?.contentSize = chartView.frame.size
        self.scrollView?.addSubview(chartView)
        self.scrollToSpecificIndex(self.getIndexOfScroll())
        chartView.layer.opacity = 1.0
        
        print("-count of pluckedData: \(pluckedData.count)")
        
//        if self.currentScreenIndex == self.dataGroup.count - 1 {
//            self.directSetOffsetX(self.scrollView!.contentSize.width - self.scrollView!.width)
//        }
    }
    
    
//    private func directSetOffsetX(value: CGFloat) {
//        self.automaticSwitch = true
//        self.offsetX = value
//        self.automaticSwitch = false
//    }
}

extension ChartViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print("viewWillBeginDragging contentOffset: \(scrollView.contentOffset)")
        self.beginOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print("viewDidEndDecelerating contentOffset: \(scrollView.contentOffset)")
        self.endOffsetX = scrollView.contentOffset.x
        
        if self.endOffsetX > self.beginOffsetX {
            print("to left")
            if self.currentScreenIndex < self.dataGroup.count - 1 {
                self.currentScreenIndex += 1
                self.redrawChart()
            }
            
        }
        if self.endOffsetX < self.beginOffsetX {
            print("to right")
            if self.currentScreenIndex > 0 {
                self.currentScreenIndex -= 1
                self.redrawChart()
         
            }
        }
        print("current index: \(self.currentScreenIndex)")
        
        
//        // The last screen
//        if self.currentScreenIndex == self.dataGroup.count - 1 {
//            self.directSetOffsetX(self.scrollView!.width)
//            return
//        }
//        
//        // The first screen
//        if self.currentScreenIndex == 0 {
//            self.directSetOffsetX(0)
//            return
//        }
//        
//        if scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x <= scrollView.contentSize.width - scrollView.width {
//            self.offsetX = scrollView.contentOffset.x
//        }
    }
}
