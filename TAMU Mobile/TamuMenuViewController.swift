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
        case yell
        case calendar
        case contacts
        case howdy
    }
    var categories = ["ATHLETICS", "YELLS", "CALENDAR", "CONTACTS", "HOWDY"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if indexPath.row == menuTitle.athletics.rawValue{
            performSegueWithIdentifier("athletics", sender: nil)
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
            self.presentViewController(yellVC, animated: true, completion: nil)
        }
        else if indexPath.row == menuTitle.contacts.rawValue{
            performSegueWithIdentifier("contacts", sender: nil)
        }
        else if indexPath.row == menuTitle.calendar.rawValue{
            let calendarVC = CalendarViewController()
            self.navigationController?.pushViewController(calendarVC, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TAMUCell
        cell.mainLabel.text = categories[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellHeight = CGFloat(view.frame.height / CGFloat(categories.count))
        return cellHeight - 20.0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
}
