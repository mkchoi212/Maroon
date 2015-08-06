//
//  FoodLocation.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/26/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation

class FoodLocation {
    var name = String()
    var address = String()
    var city = String()
    var state = String()
    var zip = String()
    var lat = String()
    var lon = String()
    
    init(name : String, address : String, city : String, state : String, zip : String, lat : String, lon : String) {
        self.name = name
        self.address = address
        self.city = city
        self.state = state
        self.zip = zip
        self.lat = lat
        self.lon = lon
    }
    
    convenience init() {
        self.init(name : "", address : "asdf", city : "College Station", state : "TX", zip : "77840", lat : "lat", lon : "lon")
    }
}