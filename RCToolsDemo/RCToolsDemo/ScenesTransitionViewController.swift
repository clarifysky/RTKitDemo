//
//  ScenesTransitionViewController.swift
//  RCToolsDemo
//
//  Created by Rex Cao on 25/9/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit

class ScenesTransitionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let actions = ["transitionFromViewController", "presentViewController"]
    let cellIdentifier = "transition"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        println("\(RCTools.Window().keyWindow()?.subviews.count)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindFromDetailView(sender: UIStoryboard) {
        
    }
    
    func performTransition(transition: String) {
        switch transition {
            case "transitionFromViewController":
                self.transitionFromVC()
            break
            case "presentViewController":
                
            break
        default: break
        }
    }
    
    /**
     * TransitionFromViewController needs that two VC belong to a common parent view controller.
     * Their parent view controller take the responsibility to handle the transition effect.
     */
    func transitionFromVC() {
//        let toVC = ContainerViewController()
        let toVC = UIStoryboard.VCWithSpecificSBAndSBID(SBName: "Main", SBID: "ContainerViewController")
        presentViewController(toVC, animated: true, completion: nil)
    }
}

extension ScenesTransitionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.actions.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = self.actions[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performTransition(self.actions[indexPath.row])
    }
}
