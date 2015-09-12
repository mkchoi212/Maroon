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
    var urlString = String()
    var requestURL = NSURL()
    var customTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (requestURL.absoluteString == nil) {
            if urlString == "http://www.coolaf.co" {
                self.title = "waddup"
            }
            else if urlString == "http://transport.tamu.edu/busroutes/" {
                self.title = "Bus Routes"
            }
            else{
                self.title = customTitle
            }
            requestURL = NSURL(string: urlString)!
        }
        else{
            let request = NSURLRequest(URL: requestURL)
             self.title = customTitle
        }

        let request = NSURLRequest(URL: requestURL)
        webView.loadRequest(request)

        
        webView.delegate = progressProxy
        progressProxy.webViewProxyDelegate = self
        progressProxy.progressDelegate = self
        let progressBarHeight = CGFloat(2.5)
        let navbarBounds = self.navigationController?.navigationBar.bounds
        let barFrame = CGRectMake(0, navbarBounds!.size.height-progressBarHeight, navbarBounds!.size.width-progressBarHeight, progressBarHeight)
        progressView = NJKWebViewProgressView(frame: barFrame)
        progressView.progressBarView.backgroundColor = UIColor.whiteColor()
        progressView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleTopMargin
        
    }
    
    @IBAction func shareArticle(sender: AnyObject) {
        let objectsToShare = [customTitle, requestURL]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        presentViewController(activityVC, animated: true, completion: { () -> Void in
            UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        })
    }
    
    @IBAction func dismissVC(sender: AnyObject) {
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
