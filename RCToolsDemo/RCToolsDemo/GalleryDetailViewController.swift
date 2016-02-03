//
//  GalleryDetailViewController.swift
//  RCToolsDemo
//
//  Created by Apple on 10/23/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

protocol GalleryDataDelegate {
    func handleLongPress(recognizer: UILongPressGestureRecognizer)
    func dismissGalleryDetail()
}

class GalleryDetailViewController: UIViewController {
    var imageURLs: [String]?
    var imageCurrentIndex: Int = 0
    // Because image is loaded asynchronously, so you should not append nsdata to an array.
    var imageViewsLoaded: [Bool]?
    private var imagesCollection: UICollectionView?
    private var imageDatas: [NSData?] = [NSData?]()
    private var uiimages: [UIImage?] = [UIImage?]()
    private var imageFrames: [CGRect?] = [CGRect?]()
    // Create blur effect for the view, only available after ios 8.0
    private var effectView: UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.tag = 0
        
        // Add blur effect, only available after ios 8.0
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        self.effectView = UIVisualEffectView(effect: blur)
        self.effectView!.frame = self.view.bounds
        self.view.addSubview(self.effectView!)
        
        for var i = 0; i < self.imageURLs!.count; i++ {
            self.imageViewsLoaded?.append(false)
            self.imageDatas.append(nil)
            self.uiimages.append(nil)
            self.imageFrames.append(nil)
        }
        // CollectionView
        self.attachCollection()
        self.attachClose()
        
//        // Gesture
//        let tapGesture = UITapGestureRecognizer(target: self, action: "viewTapped:")
//        // need tap once.
//        tapGesture.numberOfTapsRequired = 1
//        // need one finger.
//        tapGesture.numberOfTouchesRequired = 1
//        self.view.addGestureRecognizer(tapGesture)
        
        println(self.imageURLs)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewTapped(recognizer: UITapGestureRecognizer) {
        println(recognizer.view?.tag)
        switch recognizer.state {
        case .Ended:
            dismissViewControllerAnimated(true, completion: nil)
        default: break
        }
    }
    
    private func attachClose() {
        let closeButton = UIButton()
        closeButton.setTitle("Close", forState: .Normal)
        closeButton.sizeToFit()
        closeButton.frame.origin = CGPointMake(16, 16)
        closeButton.addTarget(self, action: "dismissSelf", forControlEvents: .TouchUpInside)
        self.effectView!.addSubview(closeButton)
    }
    
    func dismissSelf() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func attachCollection() {
        let flowLayout = UICollectionViewFlowLayout()
        let itemSizeWidth = self.view.bounds.width
        let itemSizeHeight = self.view.bounds.height
        flowLayout.itemSize = CGSizeMake(itemSizeWidth, itemSizeHeight)
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        self.imagesCollection = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        self.imagesCollection?.scrollEnabled = true
        self.imagesCollection?.registerClass(ImagesCell.self, forCellWithReuseIdentifier: "images")
        self.imagesCollection?.delegate = self
        self.imagesCollection?.dataSource = self
        self.imagesCollection?.backgroundColor = UIColor.clearColor()
        self.imagesCollection?.tag = 1
        
        self.imagesCollection?.showsHorizontalScrollIndicator = false
        // Set this to true to tell UISCollView that scroll its width while every scrolling.
        self.imagesCollection?.pagingEnabled = true
        
        self.effectView!.addSubview(self.imagesCollection!)
        
        // Scroll to specific item.
        self.imagesCollection?.scrollToItemAtIndexPath(NSIndexPath(forRow: self.imageCurrentIndex, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
    }
    
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError != nil {
            println("something goes wrong")
        }
        self.showPop("saved")
    }
}


extension GalleryDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageURLs!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = self.imagesCollection?.dequeueReusableCellWithReuseIdentifier("images", forIndexPath: indexPath) as? ImagesCell
        if cell == nil {
            let cellOrigin = RCTools.Math.originInParentView(sizeOfParentView: collectionView.bounds.size, sizeOfSelf: self.view.bounds.size)
            cell = ImagesCell(frame: CGRect(origin: cellOrigin, size: self.view.bounds.size))
        } else {
            cell?.dataDelegate = self
            if self.imageViewsLoaded![indexPath.row] == false {
                cell?.row = indexPath.row
                cell?.loadImage(self.imageURLs![indexPath.row], loadedHandler: {
                    (index, imageData, newFrame) in
                    println("image loaded")
                    self.imageDatas[index] = imageData
                    self.imageFrames[index] = newFrame
                    self.uiimages[index] = UIImage(data: imageData!)
                    
                    self.imageViewsLoaded![index] = true
                })
            } else {
                cell?.imageView?.frame = self.imageFrames[indexPath.row]!
                cell?.imageView?.image = self.uiimages[indexPath.row]
                cell?.imageContainer!.contentSize = cell!.imageContainer!.bounds.size
            }
            
//            cell?.imageContainer?.layer.borderColor = UIColor.whiteColor().CGColor
//            cell?.imageContainer?.layer.borderWidth = 1.0
        }
        return cell!
    }
}

extension GalleryDetailViewController: GalleryDataDelegate {
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .Began:
            println("began")
            let imageView = recognizer.view as! UIImageView
            let image = imageView.image
            UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
            break
        case .Changed:
            println("changed")
            break
        case .Ended:
            println("ended")
            break
        default: break
        }
    }
    
    func dismissGalleryDetail() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}