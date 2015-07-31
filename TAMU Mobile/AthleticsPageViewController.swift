//
//  AthleticsPageViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/26/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation
import GUITabPagerViewController
import FoldingTabBar

class AthleticsPageViewController: GUITabPagerViewController, GUITabPagerDelegate, GUITabPagerDataSource, YALTabBarInteracting {
    
    let story = UIStoryboard(name: "Main", bundle: nil)
    
    enum SlideType : Int {
        case Schedule
        case News
        case Now
    }
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

        if let celltype = SlideType(rawValue: index){
            switch celltype{
            case .Schedule:
                let scheduleVC = story.instantiateViewControllerWithIdentifier("schedule") as! ScheduleViewController
                return scheduleVC
            case .News:
                 let newsVC = story.instantiateViewControllerWithIdentifier("news") as! NewsTableViewController
                return newsVC
            case .Now:
                return TwitterViewController()
            }
        }
        else{
            return UIViewController()
        }
    }
    
    
    func titleForTabAtIndex(index: Int) -> String! {
        if let celltype = SlideType(rawValue: index){
            switch celltype{
            case .Schedule:
                return "SCHEDULE"
            case .News:
                return "NEWS"
            case .Now:
                return "NOW"
            }
        }
        else{
            return nil
        }
    }
    
    func extraRightItemDidPressed(){
        self.navigationController?.popViewControllerAnimated(true)
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
        return UIFont.systemFontOfSize(16.0)
    }
    
    func titleColor() -> UIColor! {
        return UIColor.whiteColor()
    }
    
}
