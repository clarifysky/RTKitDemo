//
//  GalleryDetailViewController.swift
//  RCToolsDemo
//
//  Created by Apple on 10/23/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

protocol GalleryDataDelegate {
    func saveImage(index: Int, image: UIImage, frame: CGRect)
    func handleLongPress(recognizer: UILongPressGestureRecognizer)
}

class GalleryDetailViewController: UIViewController {
    var images: [String]?
    var imageCurrentIndex: Int = 0
    // Because image is loaded asynchronously, so you should not append nsdata to an array.
    var imageViewsLoaded: [Bool]?
    private var imagesCollection: UICollectionView?
    var image: [UIImage?] = [UIImage?]()
    var frames: [CGRect?] = [CGRect?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for var i = 0; i < self.images!.count; i++ {
            self.imageViewsLoaded?.append(false)
            self.image.append(nil)
            self.frames.append(nil)
        }
        // CollectionView
        self.attachCollection()
        
        // Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: "viewTapped:")
        self.view.addGestureRecognizer(tapGesture)
        
        // Load current image
//        self.loadImage(self.imageCurrentIndex, imageURL: self.images![self.imageCurrentIndex])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    private func loadImage(index: Int, imageURL: String) {
//        println(self.imageViewsLoaded![index])
//        println(imageURL)
//        if self.imageViewsLoaded![index] == false {
//            let spinnerOriginal = RCTools.Math.originInParentView(sizeOfParentView: self.view.bounds.size, sizeOfSelf: CGSizeMake(30, 30))
//            let spinner = UIActivityIndicatorView(frame: CGRectMake(self.view.bounds.width * CGFloat(index) + spinnerOriginal.x, spinnerOriginal.y, 30, 30))
//            self.view.addSubview(spinner)
//            spinner.startAnimating()
//            
//            let qos = Int(QOS_CLASS_USER_INITIATED.value)
//            dispatch_async(dispatch_get_global_queue(qos, 0), {
//                let imageData = NSData(contentsOfURL: NSURL(string: imageURL)!)
//                dispatch_async(dispatch_get_main_queue(), {
//                    spinner.stopAnimating()
//                    spinner.removeFromSuperview()
//                    
//                    let image = UIImage(data: imageData!)
//                    let newSize = RCTools.Math.sizeFitContainer(ContainerSize: self.view.bounds.size, contentSize: image!.size)
//                    let imageOriginal = RCTools.Math.originInParentView(sizeOfParentView: self.view.bounds.size, sizeOfSelf: newSize)
//                    let imageView = UIImageView()
//                    imageView.frame = CGRectMake(self.view.bounds.width * CGFloat(index) + imageOriginal.x, imageOriginal.y, newSize.width, newSize.height)
//                    imageView.image = image
//                    self.view.addSubview(imageView)
//                    
//                    self.imageViewsLoaded![index] = true
//                })
//            })
//        }
//    }
    
    func viewTapped(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .Ended:
            dismissViewControllerAnimated(true, completion: nil)
        default: break
        }
    }
    
    private func attachCollection() {
        let flowLayout = UICollectionViewFlowLayout()
        let itemSizeWidth = self.view.bounds.width
        let itemSizeHeight = self.view.bounds.height
        flowLayout.itemSize = CGSizeMake(itemSizeWidth, itemSizeHeight)
        flowLayout.scrollDirection = .Horizontal
        self.imagesCollection = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        self.imagesCollection?.scrollEnabled = true
        self.imagesCollection?.registerClass(ImagesCell.self, forCellWithReuseIdentifier: "images")
        self.imagesCollection?.delegate = self
        self.imagesCollection?.dataSource = self
        
        self.imagesCollection?.showsHorizontalScrollIndicator = false
        // Set this to true to tell UISCollView that scroll its width while every scrolling.
        self.imagesCollection?.pagingEnabled = true
        
        self.view.addSubview(self.imagesCollection!)
        
        // Scroll to specific item.
        self.imagesCollection?.scrollToItemAtIndexPath(NSIndexPath(forRow: self.imageCurrentIndex, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
    }
    
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError != nil {
            println("something goes wrong")
        }
//        println("saved")
        self.showPop("saved")
    }
}


extension GalleryDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = self.imagesCollection?.dequeueReusableCellWithReuseIdentifier("images", forIndexPath: indexPath) as! ImagesCell
        cell.dataDelegate = self
        if self.imageViewsLoaded![indexPath.row] == false {
            cell.row = indexPath.row
            cell.imageURL = self.images![indexPath.row]
        } else {
            cell.imageView?.frame = self.frames[indexPath.row]!
            cell.imageView?.image = self.image[indexPath.row]
        }
        return cell
    }
}

extension GalleryDetailViewController: GalleryDataDelegate {
    func saveImage(index: Int, image: UIImage, frame: CGRect) {
        self.image[index] = image
        self.frames[index] = frame
        self.imageViewsLoaded![index] = true
    }
    
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
}