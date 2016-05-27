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
    private let url = "http://120.24.165.30/gallery.html"
    private var imageURLs: [String]?
    
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
        refreshButton.addTarget(self, action: #selector(GalleryBrowserViewController.refreshBrowser), forControlEvents: .TouchUpInside)
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
        let webView = WKWebView(frame: self.view.bounds, configuration: config)
        self.webView = webView
        self.webView?.navigationDelegate = self
        self.view.addSubview(self.webView!)
        
        
        // Spinner
        let spinnerSize: CGFloat = 30
        let spinnerOrigin = RTMath.centerOrigin(self.view.bounds.size, childSize: CGSizeMake(spinnerSize, spinnerSize))
        let spinner = UIActivityIndicatorView(frame: CGRectMake(spinnerOrigin.x, spinnerOrigin.y, spinnerSize, spinnerSize))
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.spinner = spinner
        self.view.addSubview(self.spinner!)
        
        // LoadUrl
        let url: NSURL = NSURL(string: RTText.encodeUrl(self.url))!
        let request = NSURLRequest(URL: url)
        self.webView!.loadRequest(request)
    }
    
    func presentGalleryDetail(imageCurrentIndex: Int, images: [String]) {
        let galleryDetailVC = RTView.viewController("Components", storyboardID: "GalleryDetailViewController") as! GalleryDetailViewController
//        let galleryDetailVC = UIStoryboard.VCWithSpecificSBAndSBID(SBName: "Components", SBID: "GalleryDetailViewController") as! GalleryDetailViewController
        galleryDetailVC.imageCurrentIndex = imageCurrentIndex
        galleryDetailVC.imageURLs = images
        galleryDetailVC.view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        var testArr = [Bool]()
        for _ in 0 ..< images.count {
            testArr.append(false)
        }
        galleryDetailVC.imageViewsLoaded = testArr
        
        // Make view controller which will be present is transparent.
        // Below only available after ios 8.0.
        galleryDetailVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        galleryDetailVC.providesPresentationContextTransitionStyle = true
        galleryDetailVC.definesPresentationContext = true
        galleryDetailVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        
        // IOS version before ios 8.0, try below.
//        self.view.window?.rootViewController?.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
//        presentViewController(galleryDetailVC, animated: true, completion: nil)
//        self.view.window?.rootViewController?.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        
//        self.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
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
            RTPrint.shareInstance().prt("You triggered sharing")
        } else {
            let sentData = message.body as? Dictionary<String, AnyObject>
            RTPrint.shareInstance().prt("sentData: \(sentData)")
            
            if let type = sentData!["type"] as? String {
                if type == "index" {
                    let cid = sentData!["data"] as! Int
                    RTPrint.shareInstance().prt("index: \(cid)")
                    self.presentGalleryDetail(cid, images: self.imageURLs!)
                } else {
                    self.imageURLs = sentData!["data"] as? [String]
                }
            }
        }
    }
}