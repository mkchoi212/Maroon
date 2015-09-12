//
//  TwitterViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/30/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation
import TwitterKit
import CWStatusBarNotification

class TwitterViewController: TWTRTimelineViewController, TWTRTweetViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        Twitter.sharedInstance().logInGuestWithCompletion { session, error in
            if let validSession = session {
                let client = Twitter.sharedInstance().APIClient
                self.dataSource = TWTRUserTimelineDataSource(screenName: "12thman", APIClient: client)
            } else {
                NotificationManager.sharedInstance.displayNotificationwithType(NotificationManager.Colors.Warning, style: NotificationManager.Styles.Status, message: "Could not connect to Twitter's servers. Opps")
            }
        }
    }

    func tweetView(tweetView: TWTRTweetView, didTapURL url: NSURL) {
        pushWebView(url)
    }
    
    func tweetView(tweetView: TWTRTweetView, didSelectTweet tweet: TWTRTweet) {
        pushWebView(tweet.permalink)
    }
    
    func pushWebView(url : NSURL){
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let webVC = mainSB.instantiateViewControllerWithIdentifier("webview") as! WebViewController
        webVC.requestURL = url
        webVC.customTitle = "Twtr"
        navigationController?.pushViewController(webVC, animated: true)
    }
}

