//
//  Contacts.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 8/16/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation

class Contacts {
    var name = String()
    var phone = String()
    
    init(name : String, phone : String) {
        self.name = name
        self.phone = phone
    }
    
    convenience init(){
        self.init(name : "The Creator", phone : "3167374103")
    }
}