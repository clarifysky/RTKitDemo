//
//  AutoLayoutViewController.swift
//  
//
//  Created by Rex Tsao on 2/25/16.
//
//

import UIKit

class AutoLayoutViewController: UIViewController {

    @IBOutlet weak var labelTest: UILabel!
    @IBOutlet weak var labelHello: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toggleContents(sender: UIButton) {
        if self.labelTest.text == "Label" {
            self.labelTest.text = "This is some words just for test whether the view will fit its child: UILabel.\n Good lulck!"
        } else {
            self.labelTest.text = "Label"
        }
        
        if self.labelHello.text == "Hello" {
            self.labelHello.text = "This is some words just for testing whether the view will fit its child: UILabel.\n Good lulck!"
        } else {
            self.labelHello.text = "Hello"
        }
    }
}
