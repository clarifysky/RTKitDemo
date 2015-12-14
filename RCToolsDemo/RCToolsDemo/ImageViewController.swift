//
//  ImageViewController.swift
//  
//
//  Created by Rex Tsao on 12/14/15.
//  Based on GIFImageView from: https://github.com/kiritmodi2702/GIFIamgeView_Swift
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var gifImageView: UIImageView!
    private var animating = false
    private var animatedImageData: NSData?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gifPath = NSBundle.mainBundle().pathForResource("496", ofType: "gif")
        let imageData = NSData(contentsOfFile: gifPath!)
        self.gifImageView.image = UIImage.animatedImageWithAnimatedGIFData(imageData!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startAnimating(sender: UIButton) {
        if self.animatedImageData == nil {
            let gifPath = NSBundle.mainBundle().pathForResource("496", ofType: "gif")
            self.animatedImageData = NSData(contentsOfFile: gifPath!)
        }
        
        if self.animating == false {
            self.imageButton.setImage(UIImage.animatedImageWithAnimatedGIFData(self.animatedImageData), forState: .Normal)
            self.animating = true
        } else {
            self.imageButton.setImage(nil, forState: .Normal)
            self.animating = false
        }
    }
    
    
}
