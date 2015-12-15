//
//  GalleryBrowserViewController.swift
//  RCToolsDemo
//
//  Created by Apple on 10/23/15.
//  Copyright (c) 2015 rexcao. All rights reserved.
//

import UIKit
import WebKit

class GalleryBrowserViewController: UIViewController {
    
    var webView: WKWebView?
    var spinner: UIActivityIndicatorView?
    private let url = "http://www.rexcao.net/test/gallery.html"
    private var images: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.attachRefresh()
        self.attachBrowser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func attachRefresh() {
        let refreshButton = UIButton(frame: CGRectMake(0, 0, 100, 20))
        refreshButton.setTitle("Refresh", forState: .Normal)
        refreshButton.setTitleColor(UIColor.purpleColor(), forState: .Normal)
//        refreshButton.tintColor = self.navigationItem.leftBarButtonItem?.tintColor
        refreshButton.addTarget(self, action: "refreshBrowser", forControlEvents: .TouchUpInside)
        refreshButton.sizeToFit()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: refreshButton)
    }
    
    func refreshBrowser() {
        self.webView?.reload()
    }

    func attachBrowser() {
        let config = WKWebViewConfiguration()
        config.userContentController.addScriptMessageHandler(self, name: "share")
        config.userContentController.addScriptMessageHandler(self, name: "test")
        
        // WebView
        var webView = WKWebView(frame: self.view.bounds, configuration: config)
        self.webView = webView
        self.webView?.navigationDelegate = self
        self.view.addSubview(self.webView!)
        
        
        // Spinner
        let spinnerSize: CGFloat = 30
        let spinnerOrigin = RCTools.Math.originInParentView(sizeOfParentView: self.view.bounds.size, sizeOfSelf: CGSizeMake(spinnerSize, spinnerSize))
        var spinner = UIActivityIndicatorView(frame: CGRectMake(spinnerOrigin.x, spinnerOrigin.y, spinnerSize, spinnerSize))
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.spinner = spinner
        self.view.addSubview(self.spinner!)
        
        // LoadUrl
        let url: NSURL = NSURL(string: RCTools.Characters.encodeUrl(self.url))!
        let request = NSURLRequest(URL: url)
        self.webView!.loadRequest(request)
    }
    
    func presentGalleryDetail(imageCurrentIndex: Int, images: [String]) {
        let galleryDetailVC = UIStoryboard.VCWithSpecificSBAndSBID(SBName: "Components", SBID: "GalleryDetailViewController") as! GalleryDetailViewController
        galleryDetailVC.imageCurrentIndex = imageCurrentIndex
        galleryDetailVC.images = images
        galleryDetailVC.view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        var testArr = [Bool]()
        for var i = 0; i < images.count; i++ {
            testArr.append(false)
        }
        galleryDetailVC.imageViewsLoaded = testArr
        // Set modalPresentationStyle to this to make vc which will be presented to be transparent.
        self.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        presentViewController(galleryDetailVC, animated: true, completion: nil)
    }
}

// Conform this delegate to implement some operation for WKWebView
extension GalleryBrowserViewController: WKNavigationDelegate {
    // Invoke when navigation starts
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.spinner?.startAnimating()
    }
    
    // Invoke when navigation complete
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        self.spinner?.stopAnimating()
    }
}

extension GalleryBrowserViewController: WKScriptMessageHandler {
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if message.name == "share" {
            println("You triggered sharing")
        } else {
            let sentData = message.body as? Dictionary<String, AnyObject>
            println("sentData: \(sentData)")
            
            if let type = sentData!["type"] as? String {
                if type == "index" {
                    let cid = sentData!["data"] as! Int
                    println("index: \(cid)")
                    self.presentGalleryDetail(cid, images: self.images!)
                } else {
                    self.images = sentData!["data"] as? [String]
                }
            }
        }
    }
}