//
//  CampusFood.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/26/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation

class CampusFood {
    var address = FoodLocation()
    var hours = [Hours]()
    var open = Bool()
    
    init(address : FoodLocation, hours : [Hours], open : Bool) {
        self.address = address
        self.hours = hours
    }
    
    convenience init() {
        self.init(address : FoodLocation(), hours : [Hours](), open : true)
    }
    
}