//
//  TamuMenuViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/26/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation

class TamuMenuViewController: UITableViewController {
    enum menuTitle : Int {
        case athletics
        case howdy
        case yell
        case calendar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "A&M"
        
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if indexPath.row == menuTitle.athletics.rawValue{
            
        }
        else if indexPath.row == menuTitle.howdy.rawValue{
            let alertController = UIAlertController(title: "Confirmation", message: "Open Howdy in Safari?", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: nil)
            alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                UIApplication.sharedApplication().openURL(NSURL(string:"https://howdy.tamu.edu")!)
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else if indexPath.row == menuTitle.yell.rawValue{
            let yellVC = storyboard?.instantiateViewControllerWithIdentifier("yells") as! YellsViewController
            self.navigationController?.pushViewController(yellVC, animated: true)
        }
        else if indexPath.row == menuTitle.calendar.rawValue{
            let calendarVC = CalendarViewController()
            self.navigationController?.pushViewController(calendarVC, animated: true)
        }
    }
    
}
