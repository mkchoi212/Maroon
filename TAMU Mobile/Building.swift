//
//  Building.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/30/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation

class Building {
    var abbrev = String()
    var name = String()
    var address = String()
    var city = String()
    var zip = Int()
    var section = String()
    
    init(name : String, address : String, city : String, zip : Int, section : String) {
        self.name = name
        self.address = address
        self.city = city
        self.zip = zip
        self.section = section
    }
    
    convenience init() {
        self.init(name : "building", address : "campus", city : "College Station", zip : 77840, section : "Main Campus")
    }
   
}