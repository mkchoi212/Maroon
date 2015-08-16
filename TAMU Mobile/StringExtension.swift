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
            return UIColor(red: 0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
        else if self == "Arts & Humanities"{
            return UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        }
        else if self == "Health & Environment"{
            return UIColor(red: 76.0/255.0, green: 209.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        }
        else if self == "News Releases"{
            return UIColor.purpleColor()
        }
        else {
            return UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 85.0/255.0, alpha: 1.0)
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