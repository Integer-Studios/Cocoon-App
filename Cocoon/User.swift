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
    let authentication: Authentication;
    
    init (username: String, accessToken: String) {
        
        authentication = Authentication(username: username, accessToken: accessToken)
        
    }
    
    struct Authentication {
        
        var username: String
        var accessToken: String
        
    }
    
    func loadInfo() {
        //request for kids friends and groups
        let requestManager = RequestManager()
        requestManager.sendRequest("/user/info/", parameters: ["":""], responseHandler: handleInfoResponse)
    }
    
    func handleInfoResponse(data : AnyObject?) {
        
    }
    
}