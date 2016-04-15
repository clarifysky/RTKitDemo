//
//  DictionaryViewController.swift
//  RCToolsDemo
//
//  Created by Apple on 10/20/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class DictionaryViewController: UIViewController {

    let testObject: AnyObject = [
        "one",
        "two",
        "three",
        "four",
        "five",
        "six"
    ]
    let testObject1: AnyObject = [
        1: "one",
        2: "two",
        3: "three",
        4: "four",
        5: "five",
        6: "six"
    ]
    @IBOutlet weak var resBefore: UILabel!
    @IBOutlet weak var resAfter: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.resBefore.text = "\(self.testObject)"
        print("result before convert:")
        print("\(self.testObject)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func convertPressed(sender: UIButton) {
        let resDic = self.testObject as! [AnyObject]
        print("result after convert:")
        print(resDic)
        self.resAfter.text = "\(resDic)"
    }
}
