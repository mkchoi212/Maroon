//
//  StringExtension.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/29/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation

extension String {
    
    func getHour() -> Int {
        var fullTime = split(self) {$0 == ":"}
        return fullTime.first!.toInt()!
    }
    
    func getMinutes() -> Int {
        var fullTime = split(self) {$0 == ":"}
        return fullTime.last!.toInt()!
    }
    
    func getCategoryColor() -> UIColor{
        if self == "Faculty & Staff"{
            return UIColor(netHex: 0x007AFF)
        }
        else if self == "Arts & Humanities"{
            return UIColor(netHex: 0xFFCC00)
        }
        else if self == "Health & Environment"{
            return UIColor(netHex: 0x4CD164)
        }
        else if self == "News Releases"{
            return UIColor.purpleColor()
        }
        else if self == "Business, Law, & Society"{
            return UIColor(netHex: 0x47E6BE)
        }
        else {
            return UIColor(netHex: 0xFF5E55)
        }
    }
    
    func polishURL() -> NSURL{
        var afterIMGSRC = self.componentsSeparatedByString("<img src=\"")[1]
        let isolatedString = afterIMGSRC.componentsSeparatedByString("<a href=\"").last
        if isolatedString != afterIMGSRC {
            var polishedString = isolatedString!.stringByReplacingOccurrencesOfString("\">", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            var polishedURL = polishedString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            return NSURL(string: polishedURL)!
        }
        else{
            let isolatedString = afterIMGSRC.componentsSeparatedByString("width").first
             var polishedString = isolatedString!.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            var polishedURL = polishedString.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            return NSURL(string: polishedURL)!
        }
    }
}