//
//  User.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/22/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import Foundation

class User {
    var name = ""
    var kids : [Link] = []
    var friends : [Link] = []
    var groups : [Link] = []
    var menuItems : [String] = ["Family", "Friends", "Groups", "Settings", "Invite"]
    let authentication: Authentication
    
    init (username: String, accessToken: String) {
        
        authentication = Authentication(username: username, accessToken: accessToken)
        
    }
    
    func loadInfo() {

        Cocoon.requestManager.sendRequest("/user/info/", parameters: ["":""], responseHandler: handleInfoResponse)
        
    }
    
    func handleInfoResponse(data : NSMutableDictionary) {
        
        if (data.count != 0) {
            
            name = data["name"] as! String
            
            let kidsResponse = data["kids"] as! NSArray
            
            for kidObject in kidsResponse {
                
                var kid = kidObject as! NSMutableDictionary
                kids.append(Link(id: (kid["id"] as! String).toInt()!, displayName: kid["name"] as! String))
                
            }
                        
        }
        
    }
    
    func saveAuthentication() {
        
        Cocoon.keychain.mySetObject(authentication.accessToken, forKey:kSecValueData)
        Cocoon.keychain.writeToKeychain()
        NSUserDefaults.standardUserDefaults().setObject(authentication.username, forKey: "username")
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "authenticated")
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
    func deauthenticate() {
        
        Cocoon.keychain.mySetObject("", forKey:kSecValueData)
        Cocoon.keychain.writeToKeychain()
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "username")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "authenticated")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        
    }
    
    struct Authentication {
        
        var username: String
        var accessToken: String
        
    }
    
    struct Link {
        
        var id: Int
        var displayName: String
        
    }
    
}