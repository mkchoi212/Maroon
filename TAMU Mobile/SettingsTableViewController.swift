//
//  SettingsTableViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/28/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation
import MessageUI

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    enum TableSections: Int{
        case Legal, Coolio, VersionNumber
    }
    enum CoolioIndex : Int{
        case About, Contact, Rate
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (indexPath.section == TableSections.Coolio.rawValue && indexPath.row == CoolioIndex.Contact.rawValue){
            presentMailViewController()
        }
        if (indexPath.section == TableSections.Coolio.rawValue && indexPath.row == CoolioIndex.Rate.rawValue){
            if let requestUrl = NSURL(string: "https://itunes.apple.com/us/app/maroon/id1023616502?ls=1&mt=8") {
                UIApplication.sharedApplication().openURL(requestUrl)
            }
        }
    }
    
    // MARK: MAIL DELEGATES AND ACTIONS
    func presentMailViewController(){
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            mailComposeViewController.navigationBar.tintColor = UIColor.whiteColor()
            presentViewController(mailComposeViewController, animated: true, completion: { () -> Void in
                UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
            })
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["mike@coolaf.co", "darrencola@tamu.edu"])
        mailComposerVC.setSubject("What's good?")
        
        return mailComposerVC
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "coolaf"{
            let webVC = segue.destinationViewController as! WebViewController
            webVC.urlString = "http://www.coolaf.co"
        }
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail. Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        if result.value == MFMailComposeResultSent.value{
            NotificationManager.sharedInstance.displayNotificationwithType(NotificationManager.Colors.Success, style: NotificationManager.Styles.Status, message: "Message sent successfully")
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
