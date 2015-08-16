//
//  ContactsTableViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 8/16/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation

class ContactsTableViewController: UITableViewController {
    var contacts = [Contacts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadContacts()
    }
    
    
    func loadContacts(){
        let masterDataUrl: NSURL = NSBundle.mainBundle().URLForResource("contacts", withExtension: "json")!
        let jsonData: NSData = NSData(contentsOfURL: masterDataUrl)!
        let jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: nil) as! NSDictionary
        var contacts : NSArray = jsonResult["contacts"] as! NSArray
        for item in contacts{
            let contactItem = item as! [String : String]
            var contact = Contacts(name: contactItem["name"]!, phone: contactItem["phone"]!)
            self.contacts.append(contact)
        }
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var tappedCell = tableView.cellForRowAtIndexPath(indexPath) as! ContactsCell

        var helpLabel = UILabel(frame: CGRectMake(0, 0, tappedCell.frame.width, tappedCell.frame.height))
        helpLabel.text = "HOLD FOR OPTIONS"
        helpLabel.textColor = UIColor.whiteColor()
        helpLabel.backgroundColor = UIColor.blackColor()
        helpLabel.font = UIFont(name: "GillSans-Light", size: 20)!
        helpLabel.textAlignment = NSTextAlignment.Center
        helpLabel.alpha = 0
        tappedCell.addSubview(helpLabel)
        var triggerTime = (Int64(NSEC_PER_SEC) * 1)
        
        UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            helpLabel.alpha = 1.0
        }) { (completed) -> Void in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    helpLabel.alpha = 0.0
                    }) { (completed) -> Void in
                        helpLabel.removeFromSuperview()
                }
            })
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ContactsCell
        var contact = contacts[indexPath.row]
        cell.mainLabel.text = contact.name
        cell.phoneLabel.text = contact.phone
        cell.phoneButton.addTarget(self, action: "callNumber:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.phoneButton.tag = indexPath.row
        
        var longPress = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        cell.addGestureRecognizer(longPress)
        
        return cell
    }
    
    func callNumber(sender : AnyObject){
        let selectedbutton = sender as! UIButton
        let phoneNumber = contacts[selectedbutton.tag].phone.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneNumber)")!)
    }
    
    func longPressed(gestureRecognizer : UILongPressGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerState.Ended) {
            var point = gestureRecognizer.locationInView(self.tableView)
            if let indexPath = self.tableView.indexPathForRowAtPoint(point)
            {
                let data = contacts[indexPath.row]
                var messagType = data.phone
                println(messagType)
            }
        }
        else if (gestureRecognizer.state == UIGestureRecognizerState.Began){
            
        }
    }
}
