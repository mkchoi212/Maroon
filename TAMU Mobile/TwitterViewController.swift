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
                self.dataSource = TWTRSearchTimelineDataSource(searchQuery: "#TAMU", APIClient: client)
            } else {
                println("asdf")
                let networkNotification = CWStatusBarNotification()
                networkNotification.notificationLabelBackgroundColor = UIColor.blackColor()
                networkNotification.displayNotificationWithMessage("Could not connect to Twitter's servers. Opps", forDuration: 2.0)
            }
        }
    }

    func tweetView(tweetView: TWTRTweetView!, didTapURL url: NSURL!) {
        // Open your own custom webview
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let webVC = mainSB.instantiateViewControllerWithIdentifier("webview") as! WebViewController
        webVC.urlString = url.absoluteString!
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func tweetView(tweetView: TWTRTweetView!, didSelectTweet tweet: TWTRTweet!) {
    
    }
}

