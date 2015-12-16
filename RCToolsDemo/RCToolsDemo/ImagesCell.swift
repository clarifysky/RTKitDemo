//
//  ImagesCell.swift
//  RCToolsDemo
//
//  Created by Apple on 10/26/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class ImagesCell: UICollectionViewCell {
    var imageView: UIImageView?
    var imageContainer: UIScrollView?
    private var spinner: UIActivityIndicatorView?
    var dataDelegate: GalleryDataDelegate?
    var row: Int?
    private var imageContainerOffset: CGPoint = CGPointZero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.attachImage()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attachImage() {
        self.imageContainer = UIScrollView(frame: self.bounds)
        self.imageContainer?.contentSize = self.bounds.size
        self.imageContainer?.delegate = self
        self.imageView = UIImageView()
        self.imageContainer!.addSubview(self.imageView!)
        self.addSubview(self.imageContainer!)
        
        let spinnerOrigin = RCTools.Math.originInParentView(sizeOfParentView: self.bounds.size, sizeOfSelf: CGSizeMake(30, 30))
        let spinner = UIActivityIndicatorView(frame: CGRectMake(spinnerOrigin.x, spinnerOrigin.y, 30, 30))
        self.spinner = spinner
        self.addSubview(self.spinner!)
        
        // Pinch gesture
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: "pinchHandler:")
        self.imageView?.addGestureRecognizer(pinchGesture)
    }
    
    func pinchHandler(recognizer: UIPinchGestureRecognizer) {
//        var anchor = recognizer.locationInView(self.imageView!)
//        anchor = CGPointMake(anchor.x - self.imageView!.bounds.width / 2, anchor.y - self.imageView!.bounds.height / 2)
//        
//        var affineMatrix = self.imageView!.transform
//        affineMatrix = CGAffineTransformTranslate(affineMatrix, anchor.x, anchor.y)
//        affineMatrix = CGAffineTransformScale(affineMatrix, recognizer.scale, recognizer.scale)
//        affineMatrix = CGAffineTransformTranslate(affineMatrix, -anchor.x, -anchor.y)
//        self.imageView?.transform = affineMatrix
//        
////        println("a: \(affineMatrix.a), b: \(affineMatrix.b), c: \(affineMatrix.c), d: \(affineMatrix.d), tx: \(affineMatrix.tx), ty: \(affineMatrix.ty)")
//        println("scale: \(recognizer.scale)")
//        recognizer.scale = 1
        
        
        // correct newSize, correct newContentSize, correct newImageOrigin, should scroll
        let newSize = CGSizeMake(self.imageView!.bounds.width * recognizer.scale, self.imageView!.bounds.height * recognizer.scale)
        let newChangedSize = CGSizeMake(newSize.width - self.imageView!.bounds.width, newSize.height - self.imageView!.bounds.height)
        let newContentSize = CGSizeMake(self.imageContainer!.contentSize.width + newChangedSize.width, self.imageContainer!.contentSize.height + newChangedSize.height)
        let imageOriginRatio = CGPointMake(self.imageView!.frame.origin.x / self.imageContainer!.contentSize.width, self.imageView!.frame.origin.y / self.imageContainer!.contentSize.height)
        let newImageOrigin = CGPointMake(newContentSize.width * imageOriginRatio.x, newContentSize.height * imageOriginRatio.y)
        
        self.imageContainerOffset = CGPointMake(self.imageContainerOffset.x + newChangedSize.width / 2, self.imageContainerOffset.y + newChangedSize.height / 2)
        self.imageContainer?.contentOffset = self.imageContainerOffset
        self.imageContainer?.contentSize = newContentSize
        self.imageView?.frame = CGRect(origin: newImageOrigin, size: newSize)
        
        // reset scale to 1 to make us know about growth of next time.
        // otherwise, it's total scale.
        recognizer.scale = 1
    }
    
    func loadImage(imageURL: String, loadedHandler: ((Int, NSData?, CGRect) -> Void)?) {
        self.spinner!.startAnimating()
        
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        dispatch_async(dispatch_get_global_queue(qos, 0), {
            let imageData = NSData(contentsOfURL: NSURL(string: imageURL)!)
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner!.stopAnimating()
                
                let image = UIImage(data: imageData!)
                let newSize = RCTools.Math.sizeFitContainer(ContainerSize: self.imageContainer!.bounds.size, contentSize: image!.size)
                let imageOrigin = RCTools.Math.originInParentView(sizeOfParentView: self.imageContainer!.bounds.size, sizeOfSelf: newSize)
                let newFrame = CGRectMake(imageOrigin.x, imageOrigin.y, newSize.width, newSize.height)
                self.imageView!.frame = newFrame
                self.imageView!.image = image
                
                // Gesture
                self.imageView?.userInteractionEnabled = true
                let longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
                longPressGesture.minimumPressDuration = 0.6
                self.imageView?.addGestureRecognizer(longPressGesture)
                
                loadedHandler?(self.row!, imageData, newFrame)
            })
        })
    }
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        self.dataDelegate?.handleLongPress(recognizer)
    }
    
}

extension ImagesCell: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println("scrolling")
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        println("didEndScrolling")
        self.imageContainerOffset = self.imageContainer!.contentOffset
    }
}
