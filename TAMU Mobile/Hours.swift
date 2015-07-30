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
    
    init(day : String, begTime : String, endTime : String) {
        self.day = day
        self.begTime = begTime
        self.endTime = endTime
    }
}