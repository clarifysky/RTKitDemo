//
//  MaskViewController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 17/9/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class WindowMaskViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "mask"
    
    let samples = ["presentView", "presentVCWithNav"]
    var testTool: TestWindowMask?
    var maskWindow: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        println("-initially create mask")
        self.testTool = TestWindowMask()
        self.testTool?.showMask()
        self.testTool?.addTapGesutreToMask()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createMask(sender: UIBarButtonItem) {
        println("-touch to create mask")
        println("windows before create : \(UIApplication.sharedApplication().windows.count)")
        self.testTool?.showMask()
    }
    
    
    func presentVC(#sample: String) {
        switch sample {
        case "presentView":
            let beenPresentedVC = UIStoryboard.VCWithSpecificSBAndSBID(SBName: "Main", SBID: "BeenPresentedViewController")
            presentViewController(beenPresentedVC, animated: true, completion: nil)
            break
        case "presentVCWithNav":
            let withNavBeenPresentedVC = UIStoryboard.NWithSpecificSBAndSBID(SBName: "Main", SBID: "BeenPresentedNavController")
            presentViewController(withNavBeenPresentedVC, animated: true, completion: nil)
            break
            
        default: break
        }
    }
}


extension WindowMaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.samples.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = self.samples[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.presentVC(sample: self.samples[indexPath.row])
    }
}
