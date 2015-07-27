//
//  CampusFood.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/26/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation

class CampusFood {
    var name = String()
    var address = FoodLocation()
    var hours = [Hours]()
    
    init(name : String, address : FoodLocation, hours : [Hours]) {
        self.name = name
        self.address = address
        self.hours = hours
    }
    
    convenience init() {
        self.init(name : "name", address : FoodLocation(), hours : [Hours]())
    }
    
}