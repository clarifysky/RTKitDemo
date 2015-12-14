//
//  ImageViewController.swift
//  
//
//  Created by Rex Tsao on 12/14/15.
//  Based on GIFImageView from: https://github.com/kiritmodi2702/GIFIamgeView_Swift
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var gifImageView: UIImageView!
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

}
