//
//  Hours.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/26/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation

class Hours {
    var day = String()
    var begTime = String()
    var endTime = String()
    var begDate = String()
    var endDate = String()
    
    init(day : String, begTime : String, endTime : String, begDate : String, endDate : String) {
        self.day = day
        self.begTime = begTime
        self.endTime = endTime
        self.begDate = begDate
        self.endDate = endDate
    }
}