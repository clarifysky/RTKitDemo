//
//  ExcelViewController.swift
//  RCToolsDemo
//
//  Created by Rex Tsao on 1/6/2016.
//  Copyright © 2016 rexcao. All rights reserved.
//

import UIKit

class ExcelViewController: UIViewController {

    let excelURL = "http://120.24.165.30/ee.xlsx"
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func attacVisitButton() {
        let button = UIButton()
        button.setTitle("openExcel", forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.addTarget(self, action: #selector(ExcelViewController.openExcel(_:)), forControlEvents: .TouchUpInside)
        button.sizeToFit()
        
        self.view.addSubview(button)
    }
    
    func openExcel (sender: UIButton) {
        let url = "ms-excel:ofe|u|" + self.excelURL
//        if UIApplication.sharedApplication().canOpenURL() {
//            
//        }
    }

}
