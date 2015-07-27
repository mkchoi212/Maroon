//
//  AthleticsPageViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/26/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation
import GUITabPagerViewController

class AthleticsPageViewController: GUITabPagerViewController, GUITabPagerDelegate, GUITabPagerDataSource {
    
    let story = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Athletics"
        self.dataSource = self
        self.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.reloadData()
        self.view.backgroundColor = UIColor(red: 80.0/255.0, green: 0, blue: 0, alpha: 1.0)
        self.selectTabbarIndex(0)
        super.viewWillAppear(true)
    }
    
    func numberOfViewControllers() -> Int {
        return 3
    }
    
    func viewControllerForIndex(index: Int) -> UIViewController {

        if index == 0 {
            let scheduleVC = story.instantiateViewControllerWithIdentifier("schedule") as! ScheduleViewController
            return scheduleVC
        }
        else{
            return UIViewController()
        }
    }
    
    func titleForTabAtIndex(index: Int) -> String! {
        if index == 0 {
            return "Schedule"
        }
        else if index == 1 {
            return "News"
        }
        else{
            return "Now"
        }
    }
    
    func tabHeight() -> CGFloat {
        return 50.0
    }
    
    func tabColor() -> UIColor! {
        return UIColor.whiteColor()
    }

    func tabBackgroundColor() -> UIColor! {
        return UIColor.blackColor()
    }
    
    func titleFont() -> UIFont! {
        return UIFont.systemFontOfSize(18.0)
    }
    
    func titleColor() -> UIColor! {
        return UIColor.whiteColor()
    }
}
