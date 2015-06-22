//
//  User.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/22/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import Foundation

class User {
    var email = ""
    var name = ""
    var token = ""
    var kids : [Int] = []
    var friends : [Int] = []
    var groups : [Int] = []
    
    func loadUserData() {
        //request for kids friends and groups
    }
    
}