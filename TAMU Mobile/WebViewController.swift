//
//  WebViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/28/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation
import NJKWebViewProgress

class WebViewController: UIViewController, UINavigationBarDelegate, UINavigationControllerDelegate, UIWebViewDelegate, NSURLSessionTaskDelegate,NJKWebViewProgressDelegate {

    @IBOutlet weak var webView: UIWebView!
    var progressView = NJKWebViewProgressView()
    var progressProxy = NJKWebViewProgress()
    var sessionChecked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requestURL = NSURL(string: "https://lifeplusdev.wordpress.com")!
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.addSubview(progressView)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        progressView.removeFromSuperview()
    }

    func webViewProgress(webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        progressView.setProgress(progress, animated: true)
    }

}
