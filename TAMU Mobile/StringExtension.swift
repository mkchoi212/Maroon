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
}