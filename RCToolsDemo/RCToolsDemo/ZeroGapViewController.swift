//
//  ZeroGapViewController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 30/10/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class ZeroGapViewController: UIViewController {

    private var collectionView: UICollectionView?
    private let collectionIdentifier = "colors"
    private let colors = [UIColor.blueColor(), UIColor.greenColor(), UIColor.redColor(), UIColor.purpleColor()]
    private var lastContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.attachCollection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func attachCollection() {
        // important: this will disable the inexplicable gap of items.
        self.automaticallyAdjustsScrollViewInsets = false
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Horizontal
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.itemSize = CGSizeMake(300, 100)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        self.collectionView = UICollectionView(frame: CGRectMake(0, 64, 300, 100), collectionViewLayout: flowLayout)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "colors")
        self.collectionView?.pagingEnabled = true
        
        self.collectionView?.layer.shadowOpacity = 1.0
        self.collectionView?.layer.shadowOffset = CGSizeZero
        
        self.view.addSubview(self.collectionView!)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.x
//        println(self.lastContentOffset)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        println("decelerating ended")
        for cell in self.collectionView!.visibleCells() {
            let indexPath = self.collectionView?.indexPathForCell(cell as! UICollectionViewCell)
            println("current row: \(indexPath!.row)")
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        println("animation ended")
    }
}

extension ZeroGapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colors.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView!.dequeueReusableCellWithReuseIdentifier(self.collectionIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        cell.backgroundColor = self.colors[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("you selected item at index: \(indexPath.item)")
    }
    
    // Custom UICollectionViewCell does not support long-press to show menu.
    func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) {
        println("indexPath \(indexPath.row)")
    }
    
}
