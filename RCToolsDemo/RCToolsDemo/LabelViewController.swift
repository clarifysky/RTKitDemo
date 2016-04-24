//
//  LabelViewController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 11/12/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class LabelViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var labelText: UILabel!
    var defaultFontSize: CGFloat = 17
    var defaultSliderValue: CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.defaultSliderValue = CGFloat(self.slider.value)
        self.labelText.layer.borderColor = UIColor.redColor().CGColor
        self.labelText.layer.borderWidth = 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sliderChange(sender: UISlider) {
        print("sliderChange")
        _ = self.labelText.text
        let newFontSize = self.defaultFontSize / self.defaultSliderValue! * CGFloat(sender.value)
        self.labelText.font = UIFont.systemFontOfSize(newFontSize)
    }

}
