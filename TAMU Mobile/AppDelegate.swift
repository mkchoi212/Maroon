//
//  AppDelegate.swift
//  TAMU
//
//  Created by Mike Choi on 7/25/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//
import UIKit
import FoldingTabBar
import GoogleMaps
import Fabric
import TwitterKit
import CWStatusBarNotification

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var maroonColor = UIColor(red: 80.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    let statusNotification = CWStatusBarNotification()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
       
        var pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        pageControl.backgroundColor = UIColor.whiteColor()
        
        GMSServices.provideAPIKey("AIzaSyC0WTQoKQFVeTcgBhdihj-spXNVWNZgCrg")
        SVGeocoder.setGoogleMapsAPIKey("AIzaSyDMpb-f2UPrErM80V8rcAk0RVqe9Y-8z-g")
        Fabric.with([Twitter()])

        let barFont = UIFont(name: "GillSans-Light", size: 20)!
        let barColor = UIColor.whiteColor()
        let barAttributes : [NSString : AnyObject] = [NSFontAttributeName : barFont , NSForegroundColorAttributeName : barColor]
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = maroonColor
        UINavigationBar.appearance().titleTextAttributes = barAttributes
        UINavigationBar.appearance().translucent = false
        self.window?.backgroundColor = maroonColor
        
        if NSUserDefaults.standardUserDefaults().boolForKey("tutorialSeen"){
            if let window = self.window{
                window.rootViewController = setupAnimatedTabBar()
            }
        }
        
        return true
    }
    
    func setupAnimatedTabBar() -> YALFoldingTabBarController {
        let mainStorybaord = UIStoryboard(name: "Main", bundle: nil)
        var tabBarController = mainStorybaord.instantiateViewControllerWithIdentifier("tab") as! YALFoldingTabBarController
        
        var left1 = YALTabBarItem(itemImage: UIImage(named: "explore"), leftItemImage: UIImage(named: "campus"), rightItemImage:  UIImage(named: "bus"))
        var left2 = YALTabBarItem(itemImage: UIImage(named: "food"), leftItemImage: UIImage(named: "campus"), rightItemImage: UIImage(named: "offcampus"))
        tabBarController.leftBarItems = [left1, left2]
        
        var right1 = YALTabBarItem(itemImage: UIImage(named: "home"), leftItemImage: nil, rightItemImage: UIImage(named: "tamu"))
        var right2 = YALTabBarItem(itemImage: UIImage(named: "settings"), leftItemImage: nil, rightItemImage: nil)
        tabBarController.rightBarItems = [right1, right2]
        
        tabBarController.centerButtonImage = UIImage(named: "plus_icon")
        
        tabBarController.selectedIndex = 2
        
        tabBarController.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight
        tabBarController.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset
        tabBarController.tabBarView.backgroundColor = UIColor.clearColor()
        tabBarController.tabBarView.tabBarColor = UIColor.blackColor()
        tabBarController.tabBarViewHeight = YALTabBarViewDefaultHeight
        tabBarController.tabBarView.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets
        tabBarController.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets
        
        return tabBarController
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
}

