//
//  SnapshotViewController.swift
//  RCToolsDemo
//
//  Created by Apple on 10/29/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class SnapshotViewController: UIViewController {

    @IBOutlet weak var brownView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.brownView.RCCurveShadowSide(.Top)
        self.brownView.RCCurveShadowSide(.Bottom)
        self.brownView.opaque = false
        
        let testView = UIView(frame: self.brownView.frame)
        let testLabel = UILabel()
        testLabel.text = "I am inserted above"
        testLabel.sizeToFit()
        testLabel.frame = CGRectMake(0, 0, testLabel.bounds.width, testLabel.bounds.height)
        testView.addSubview(testLabel)
        
        testView.backgroundColor = UIColor.blueColor()
        self.view.insertSubview(testView, belowSubview: self.brownView)
        self.brownView.backgroundColor = UIColor(red: 40/255, green: 240/255, blue: 144/255, alpha: 0.7)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takeSnapshot(sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(self.brownView.snapshot(), nil, nil, nil)
        self.showPop("saved")
    }
    
    @IBAction func takeScreenshot(sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(RCTools.Window().keyWindow()!.snapshot(), nil, nil, nil)
        self.showPop("saved")
    }
    
}
