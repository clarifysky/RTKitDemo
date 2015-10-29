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
