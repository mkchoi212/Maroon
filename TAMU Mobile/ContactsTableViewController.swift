//
//  ContactsTableViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 8/16/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation
import MessageUI
import CWStatusBarNotification

class ContactsTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate {
    var contacts = [Contacts]()
    let statusNotification = CWStatusBarNotification()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadContacts()
    }
    
    
    func loadContacts(){
        let masterDataUrl: NSURL = NSBundle.mainBundle().URLForResource("contacts", withExtension: "json")!
        let jsonData: NSData = NSData(contentsOfURL: masterDataUrl)!
        let jsonResult: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(jsonData, options: [])) as! NSDictionary
        let contacts : NSArray = jsonResult["contacts"] as! NSArray
        for item in contacts{
            let contactItem = item as! [String : String]
            let contact = Contacts(name: contactItem["name"]!, phone: contactItem["phone"]!)
            self.contacts.append(contact)
        }
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let tappedCell = tableView.cellForRowAtIndexPath(indexPath) as! ContactsCell

        let helpLabel = UILabel(frame: CGRectMake(0, 0, tappedCell.frame.width, tappedCell.frame.height))
        helpLabel.text = "HOLD FOR OPTIONS"
        helpLabel.textColor = UIColor.whiteColor()
        helpLabel.backgroundColor = UIColor.blackColor()
        helpLabel.font = UIFont(name: "GillSans-Light", size: 20)!
        helpLabel.textAlignment = NSTextAlignment.Center
        helpLabel.alpha = 0
        tappedCell.addSubview(helpLabel)
        
        let triggerTime = (Int64(NSEC_PER_SEC) * 1)
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ContactsCell
        let contact = contacts[indexPath.row]
        cell.mainLabel.text = contact.name
        cell.phoneLabel.text = contact.phone
        cell.phoneButton.addTarget(self, action: "callNumber:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.phoneButton.tag = indexPath.row
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        cell.addGestureRecognizer(longPress)
        
        return cell
    }
    
    func callNumber(sender : AnyObject){
        let selectedbutton = sender as! UIButton
        let phoneNumber = contacts[selectedbutton.tag].phone.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneNumber)")!)
    }
    
    func longPressed(gestureRecognizer : UILongPressGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
            let point = gestureRecognizer.locationInView(self.tableView)
            if let indexPath = self.tableView.indexPathForRowAtPoint(point)
            {
                let data = contacts[indexPath.row]
                showActionSheet(data)
            }
        }
    }
    
   func showActionSheet(contact: Contacts) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)

        let textAction = UIAlertAction(title: "Text \(contact.name)", style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            let messageVC = MFMessageComposeViewController()
            
            messageVC.body = ""
            messageVC.recipients = [contact.phone]
            messageVC.messageComposeDelegate = self
            messageVC.navigationBar.tintColor = UIColor.whiteColor()
            self.presentViewController(messageVC, animated: true, completion: { () -> Void in
                UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
            })
        })
        let callAction = UIAlertAction(title: "Call \(contact.name)", style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            let phoneNum = contact.phone.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneNum)")!)
        })
    
        let copyAction = UIAlertAction(title: "Copy to Clipboard", style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            UIPasteboard.generalPasteboard().string = contact.phone
            self.statusNotification.notificationLabelBackgroundColor = UIColor.whiteColor()
            self.statusNotification.notificationLabelTextColor = UIColor.blackColor()
            self.statusNotification.displayNotificationWithMessage("Copied to clipboard", forDuration: 2.0)
        })
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
    
        optionMenu.addAction(textAction)
        optionMenu.addAction(callAction)
        optionMenu.addAction(copyAction)
        optionMenu.addAction(cancelAction)
    
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        self.statusNotification.notificationLabelBackgroundColor = UIColor.whiteColor()
        self.statusNotification.notificationLabelTextColor = UIColor.blackColor()

        switch (result.rawValue) {
        case MessageComposeResultCancelled.rawValue:
            statusNotification.displayNotificationWithMessage("Message was canceled", forDuration: 2.0)
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.rawValue:
             statusNotification.displayNotificationWithMessage("Message failed", forDuration: 2.0)
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.rawValue:
            statusNotification.displayNotificationWithMessage("Message was sent", forDuration: 2.0)
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }
}
