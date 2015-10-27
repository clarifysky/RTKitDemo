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
    private var spinner: UIActivityIndicatorView?
    var dataDelegate: GalleryDataDelegate?
    var row: Int?
    
    var imageURL: String? {
        willSet {
            self.loadImage(newValue!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.attachImage()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attachImage() {
        self.imageView = UIImageView()
        self.addSubview(self.imageView!)
        
        let spinnerOrigin = RCTools.Math.originInParentView(sizeOfParentView: self.bounds.size, sizeOfSelf: CGSizeMake(30, 30))
        let spinner = UIActivityIndicatorView(frame: CGRectMake(spinnerOrigin.x, spinnerOrigin.y, 30, 30))
        self.spinner = spinner
        self.addSubview(self.spinner!)
    }
    
    private func loadImage(imageURL: String) {
        self.spinner!.startAnimating()
        
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        dispatch_async(dispatch_get_global_queue(qos, 0), {
            let imageData = NSData(contentsOfURL: NSURL(string: imageURL)!)
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner!.stopAnimating()
                
                let image = UIImage(data: imageData!)
                let newSize = RCTools.Math.sizeFitContainer(ContainerSize: self.bounds.size, contentSize: image!.size)
                let imageOrigin = RCTools.Math.originInParentView(sizeOfParentView: self.bounds.size, sizeOfSelf: newSize)
                let newFrame = CGRectMake(imageOrigin.x, imageOrigin.y, newSize.width, newSize.height)
                self.imageView!.frame = newFrame
                self.imageView!.image = image
                
                self.dataDelegate?.saveImage(self.row!, image: image!, frame: newFrame)
                
                // Gesture
                self.imageView?.userInteractionEnabled = true
                let longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
                longPressGesture.minimumPressDuration = 0.6
                self.imageView?.addGestureRecognizer(longPressGesture)
            })
        })
    }
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        println("imagesCell long press")
        self.dataDelegate?.handleLongPress(recognizer)
    }
}
