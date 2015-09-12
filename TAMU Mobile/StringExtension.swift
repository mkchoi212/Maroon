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
    
    var imageLinksFromHTMLString : [NSURL]{
        var matches = [NSURL]()
        var error: NSError?
        var full_range: NSRange = NSMakeRange(0, count(self))
        
        if let regex = NSRegularExpression(pattern:"(https?)\\S*(png|jpg|jpeg|gif)", options:.CaseInsensitive, error:&error){
            regex.enumerateMatchesInString(self, options: NSMatchingOptions(0), range: full_range) {
                (result : NSTextCheckingResult!, _, _) in
                
                // didn't find a way to bridge an NSRange to Range<String.Index>
                // bridging String to NSString instead
                var str = (self as NSString).substringWithRange(result.range) as String
                
                matches.append(NSURL(string: str)!)
            }
        }
        return matches
    }

}