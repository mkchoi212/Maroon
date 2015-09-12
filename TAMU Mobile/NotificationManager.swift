//
//  NotificationManager.swift
//  Maroon
//
//  Created by Mike Choi on 9/12/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation
import CWStatusBarNotification

class NotificationManager {
    
    static let sharedInstance = NotificationManager()
    var notification = CWStatusBarNotification()
    static let Colors  = (Error: 0xFF3A2D, Success: 0x4CD964, Warning: 0xFFCC00)
    static let Styles = (Nav: CWNotificationStyle.NavigationBarNotification, Status: CWNotificationStyle.StatusBarNotification)
    
    func generateAlertwithTitle(title: String, subTitle : String, secondaryAction : UIAlertAction?, tertiaryAction : UIAlertAction?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: subTitle, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: nil)
        if secondaryAction != nil{
            alertController.addAction(secondaryAction!)
        }
        if tertiaryAction != nil {
            alertController.addAction(tertiaryAction!)
        }
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    func displayNotificationwithType(color: Int, style: CWNotificationStyle, message: String){
        notification.notificationStyle = style
        notification.notificationLabelBackgroundColor = UIColor(netHex: Int(color))
        notification.displayNotificationWithMessage(message, forDuration: 2.0)
    }
    
}
