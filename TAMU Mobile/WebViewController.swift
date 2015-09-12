//
//  WebViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/28/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation
import NJKWebViewProgress
import FoldingTabBar

class WebViewController: UIViewController, UINavigationBarDelegate, UINavigationControllerDelegate, UIWebViewDelegate, NSURLSessionTaskDelegate,NJKWebViewProgressDelegate, YALTabBarInteracting {

    @IBOutlet weak var webView: UIWebView!
    var progressView = NJKWebViewProgressView()
    var progressProxy = NJKWebViewProgress()
    var sessionChecked = false
    var requestURL = NSURL()
    var customTitle = String()
    var isModal = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProgressBar()
        setupNavigationBar()
        self.title = customTitle
        
        let request = NSURLRequest(URL: requestURL)
        webView.loadRequest(request)
        webView.delegate = progressProxy
    }
    
    func setupProgressBar(){
        progressProxy.webViewProxyDelegate = self
        progressProxy.progressDelegate = self
        let progressBarHeight = CGFloat(2.5)
        let navbarBounds = self.navigationController?.navigationBar.bounds
        let barFrame = CGRectMake(0, navbarBounds!.size.height-progressBarHeight, navbarBounds!.size.width-progressBarHeight, progressBarHeight)
        progressView = NJKWebViewProgressView(frame: barFrame)
        progressView.progressBarView.backgroundColor = UIColor.whiteColor()
        progressView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleTopMargin
    }
    
    func setupNavigationBar(){
        if isModal{
            navigationController!.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "dismissVC")
        }
    }
    
    @IBAction func shareArticle(sender: AnyObject) {
        let objectsToShare = [customTitle, requestURL]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePostToFlickr, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypePostToTencentWeibo]
        
        activityVC.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        presentViewController(activityVC, animated: true, completion: { () -> Void in
            UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        })
    }
    
    func dismissVC() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.addSubview(progressView)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        progressView.removeFromSuperview()
    }

    func webViewProgress(webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        progressView.setProgress(progress, animated: true)
    }
    
    func extraLeftItemDidPressed(){
        navigationController?.popViewControllerAnimated(true)
    }

}
