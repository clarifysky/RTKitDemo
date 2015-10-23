//
//  GalleryDetailViewController.swift
//  RCToolsDemo
//
//  Created by Apple on 10/23/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class GalleryDetailViewController: UIViewController {
    var images: [String]?
    var imageCurrentIndex: Int?
    private var imageView: UIImageView?
    // Because image is loaded asynchronously, so you should not append nsdata to an array.
    private var imageData = Dictionary<Int, NSData?>()
    private var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for var i = 0; i < self.images?.count; i++ {
            self.imageData[i] = nil
        }
        self.imageView = UIImageView()
        
        let spinnerOriginal = RCTools.Math.originInParentView(sizeOfParentView: self.view.bounds.size, sizeOfSelf: CGSizeMake(30, 30))
        self.spinner = UIActivityIndicatorView(frame: CGRectMake(spinnerOriginal.x, spinnerOriginal.y, 30, 30))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func loadImage(imageURL: String) {
        self.spinner?.startAnimating()
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        dispatch_async(dispatch_get_global_queue(qos, 0), {
            let imageData = NSData(contentsOfURL: NSURL(string: imageURL)!)
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner?.stopAnimating()
                let image = UIImage(data: imageData!)
                
                let newSize = RCTools.Math.sizeFitContainer(ContainerSize: self.view.bounds.size, contentSize: image!.size)
                let imageOriginal = RCTools.Math.originInParentView(sizeOfParentView: self.view.bounds.size, sizeOfSelf: newSize)
                self.imageView?.frame = CGRectMake(imageOriginal.x, imageOriginal.y, newSize.width, newSize.height)
                self.imageView?.image = image
                
                self.imageData[self.imageCurrentIndex!] = imageData
            })
        })
    }
}
