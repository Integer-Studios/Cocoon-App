//
//  User.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/22/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import Foundation

class User {
    var kids : [Link] = []
    var friends : [Link] = []
    var groups : [Link] = []
    var menuItems : [Link] = []
    let authentication: Authentication
    var firstName: String
    var lastName: String
    
    init (username: String, accessToken: String) {
        
        authentication = Authentication(username: username, accessToken: accessToken)
        firstName = "";
        lastName = "";
        
    }
    
    func loadInfo() {

        Cocoon.requestManager.sendRequest("/user/info/", parameters: ["":""], responseHandler: handleInfoResponse)
        
    }
    
    func handleInfoResponse(data : NSMutableDictionary, status: Int) {
        
        if (data.count != 0) {
            
            firstName = data["first-name"] as! String
            lastName = data["last-name"] as! String

            let kidsResponse = data["kids"] as! NSArray
            
            for kidObject in kidsResponse {
                
                var kid = kidObject as! NSMutableDictionary
                kids.append(Link(id: (kid["id"] as! String).toInt()!, type: "kid", displayName: kid["name"] as! String))
                
            }
            
            updateMenuItems()
                        
        }
        
    }
    
    func updateMenuItems() {
        
        menuItems = [];
        
        
        for kid in kids {
            menuItems.append(kid)
        }
        
        menuItems.append(Link(id: 0, type: "default", displayName: "Family"))
        
        for friend in friends {
            menuItems.append(friend)
        }
        
        menuItems.append(Link(id: 1, type: "default", displayName: "Friends"))
        
        for group in groups {
            menuItems.append(group)
        }
        
        menuItems.append(Link(id: 2, type: "default", displayName: "Groups"))

        menuItems.append(Link(id: 3, type: "default", displayName: "Settings"))
        menuItems.append(Link(id: 4, type: "default", displayName: "Invite"))
        
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
    
}