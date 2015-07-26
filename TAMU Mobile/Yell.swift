//
//  Yell.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/26/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation

class Yell {
    var name = String()
    var passback = String()
    var call = String()

    init(name : String, passback : String, call : String) {
        self.name = name
        self.passback = passback
        self.call = call
    }
}