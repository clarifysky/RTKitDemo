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
    private var baseFrame: CGRect?
//    private var biggestContainerContentSize: CGSize?
    private var isBiggest: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.attachImage()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attachImage() {
        self.imageContainer = UIScrollView(frame: self.bounds)
        self.imageContainer?.contentSize = self.bounds.size
        self.imageContainer?.delegate = self
        self.imageView = UIImageView()
        self.imageContainer!.addSubview(self.imageView!)
        self.addSubview(self.imageContainer!)
        
        let spinnerOrigin = RTMath.centerOrigin(self.bounds.size, childSize: CGSizeMake(30, 30))
        let spinner = UIActivityIndicatorView(frame: CGRectMake(spinnerOrigin.x, spinnerOrigin.y, 30, 30))
        self.spinner = spinner
        self.addSubview(self.spinner!)
        
        // Pinch gesture
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(ImagesCell.pinchHandler(_:)))
        self.imageView?.addGestureRecognizer(pinchGesture)
        
        // Tap gesture
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(ImagesCell.doubleTapHandler(_:)))
        // This will made tapGesture to be double-tap gesture.
        doubleTapGesture.numberOfTapsRequired = 2
        // how many fingers you need to trigger the touch.
        doubleTapGesture.numberOfTouchesRequired = 1
        self.imageView?.addGestureRecognizer(doubleTapGesture)
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(ImagesCell.singleTapHandler(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        self.imageContainer?.addGestureRecognizer(singleTapGesture)
        
        // When doubleTapGesture cannot be recognized, start to recognize singleTapGesture.
        singleTapGesture.requireGestureRecognizerToFail(doubleTapGesture)
    }
    
    func pinchHandler(recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .Ended {
            print("at last, frame of imageView is: \(self.imageView!.frame)")
            print("isBiggest: \(self.isBiggest)")
            if self.imageView!.frame.width >= self.imageView!.image!.size.width {
                UIView.animateWithDuration(0.25, animations: {
                    self.resizeImageAndItsContainer(self.imageView!.image!.size)
                    }, completion: {
                        finished in
                        self.isBiggest = true
                })
            } else if self.imageView!.frame.width <= self.baseFrame!.width {
                UIView.animateWithDuration(0.25, animations: {
                    // Because when image zoomed to smallest, the scrollView has already be its final position,
                    // you only need to adjust image to its final position.
                    self.resizeImage(self.bounds.size, newSize: self.baseFrame!.size)
                    }, completion: {
                        finished in
                        self.isBiggest = false
                })
            }
        } else if recognizer.state == .Changed {
            let newSize = CGSizeMake(self.imageView!.bounds.width * recognizer.scale, self.imageView!.bounds.height * recognizer.scale)
            print("newSize: \(newSize)")
            print("baseFrameSize: \(self.baseFrame!.size)")
            print("scale: \(recognizer.scale)")
            print("changed")
            self.resizeImageAndItsContainer(newSize)
        }
        // reset scale to 1 to make us know about growth of next time.
        // otherwise, it's total scale.
        recognizer.scale = 1
    }
    
    func singleTapHandler(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            self.dataDelegate?.dismissGalleryDetail()
        }
    }
    
    func doubleTapHandler(recognizer: UITapGestureRecognizer) {
        
        if self.isBiggest {
            self.imageContainerOffset = CGPointZero
            
            UIView.animateWithDuration(0.25, animations: {
                self.imageContainer?.contentOffset = CGPointZero
                self.imageContainer?.contentSize = self.bounds.size
                self.imageView?.frame = self.baseFrame!
                }, completion: {
                    finished in
                    self.isBiggest = false
            })
        } else {
            let newSize = self.imageView!.image!.size
            let newChangedSize = CGSizeMake(newSize.width - self.imageView!.bounds.width, newSize.height - self.imageView!.bounds.height)
            let newContentSize = CGSizeMake(self.imageContainer!.contentSize.width + newChangedSize.width, self.imageContainer!.contentSize.height + newChangedSize.height)
            let newImageOrigin = RTMath.centerOrigin(newContentSize, childSize: newSize)
            
            let anchor = recognizer.locationInView(self.imageView!)
            let anchorRatio = CGPointMake(anchor.x / self.imageView!.frame.width, anchor.y / self.imageView!.frame.height)
            _ = CGPointMake(newSize.width * anchorRatio.x, newSize.height * anchorRatio.y)
            
            self.imageContainerOffset = CGPointMake(self.imageContainerOffset.x + newChangedSize.width * anchorRatio.x, self.imageContainerOffset.y + newChangedSize.height * anchorRatio.y)
            UIView.animateWithDuration(0.25, animations: {
                self.imageContainer?.contentOffset = self.imageContainerOffset
                self.imageContainer?.contentSize = newContentSize
                self.imageView?.frame = CGRect(origin: newImageOrigin, size: newSize)
                }, completion: {
                    finished in
              self.isBiggest = true
            })
        }
    }
    
    private func resizeImageAndItsContainer(newSize: CGSize) {
        // correct newSize, correct newContentSize, correct newImageOrigin, should scroll
        let newChangedSize = CGSizeMake(newSize.width - self.imageView!.bounds.width, newSize.height - self.imageView!.bounds.height)
        var newContentSize = CGSizeMake(self.imageContainer!.contentSize.width + newChangedSize.width, self.imageContainer!.contentSize.height + newChangedSize.height)
        _ = CGPointMake(self.imageView!.frame.origin.x / self.imageContainer!.contentSize.width, self.imageView!.frame.origin.y / self.imageContainer!.contentSize.height)
        let newImageOrigin = RTMath.centerOrigin(newContentSize, childSize: newSize)
        
        self.imageContainerOffset = CGPointMake(self.imageContainerOffset.x + newChangedSize.width / 2, self.imageContainerOffset.y + newChangedSize.height / 2)
        if newContentSize.width <= self.bounds.width {
            newContentSize = self.bounds.size
            self.imageContainerOffset = CGPointZero
        }
        self.imageContainer?.contentOffset = self.imageContainerOffset
        self.imageContainer?.contentSize = newContentSize
        self.imageView?.frame = CGRect(origin: newImageOrigin, size: newSize)
    }
    
    private func resizeImage(parentContentSize: CGSize, newSize: CGSize) {
        let newImageOrigin = RTMath.centerOrigin(parentContentSize, childSize: newSize)
        self.imageView?.frame = CGRect(origin: newImageOrigin, size: newSize)
    }
    
    private func contentSizeAtBiggest() -> CGSize {
        let newSize = self.imageView!.image!.size
        let newChangedSize = CGSizeMake(newSize.width - self.imageView!.bounds.width, newSize.height - self.imageView!.bounds.height)
        let newContentSize = CGSizeMake(self.imageContainer!.contentSize.width + newChangedSize.width, self.imageContainer!.contentSize.height + newChangedSize.height)
        return newContentSize
    }
    
    func loadImage(imageURL: String, loadedHandler: ((Int, NSData?, CGRect) -> Void)?) {
        self.spinner!.startAnimating()
        
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0), {
            let imageData = NSData(contentsOfURL: NSURL(string: imageURL)!)
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner!.stopAnimating()
                
                let image = UIImage(data: imageData!)
                let newSize = RTMath.sizeFitContainer(self.imageContainer!.bounds.size, contentSize: image!.size)
                let imageOrigin = RTMath.centerOrigin(self.imageContainer!.bounds.size, childSize: newSize)
                let newFrame = CGRectMake(imageOrigin.x, imageOrigin.y, newSize.width, newSize.height)
                self.baseFrame = newFrame
                self.imageView!.frame = newFrame
                self.imageView!.image = image
//                self.biggestContainerContentSize = self.contentSizeAtBiggest()
                
                // Gesture
                self.imageView?.userInteractionEnabled = true
                let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(ImagesCell.handleLongPress(_:)))
                longPressGesture.minimumPressDuration = 0.6
                self.imageView?.addGestureRecognizer(longPressGesture)
                
                loadedHandler?(self.row!, imageData, newFrame)
            })
        })
    }
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        self.dataDelegate?.handleLongPress(recognizer)
    }
    
    /// Another way of zooming handler.
    private func transformZoom(recognizer: UIPinchGestureRecognizer) {
        var anchor = recognizer.locationInView(self.imageView!)
        anchor = CGPointMake(anchor.x - self.imageView!.bounds.width / 2, anchor.y - self.imageView!.bounds.height / 2)

        var affineMatrix = self.imageView!.transform
        affineMatrix = CGAffineTransformTranslate(affineMatrix, anchor.x, anchor.y)
        affineMatrix = CGAffineTransformScale(affineMatrix, recognizer.scale, recognizer.scale)
        affineMatrix = CGAffineTransformTranslate(affineMatrix, -anchor.x, -anchor.y)
        self.imageView?.transform = affineMatrix

//        println("a: \(affineMatrix.a), b: \(affineMatrix.b), c: \(affineMatrix.c), d: \(affineMatrix.d), tx: \(affineMatrix.tx), ty: \(affineMatrix.ty)")
        print("scale: \(recognizer.scale)")
        recognizer.scale = 1
    }
}

extension ImagesCell: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        println("scrolling")
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        println("didEndScrolling")
        self.imageContainerOffset = self.imageContainer!.contentOffset
    }
}
