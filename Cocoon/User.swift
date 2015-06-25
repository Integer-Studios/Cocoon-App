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
    var families : [Link] = []
    
    var family : Link?
    
    let authentication: Authentication
    var firstName: String = ""
    var lastName: String = ""
    var facebook: Bool = false
    
    init (username: String, accessToken: String) {
        
        authentication = Authentication(username: username, accessToken: accessToken)
        
    }
    
    func loadInfo() {
        
        Cocoon.requestManager.sendRequest("/user/info/", parameters: ["":""], responseHandler: handleInfoResponse, errorHandler: handleInfoError)
        
    }
    
    func getFamily() -> Link? {
        
        return self.family
        
    }
    
    func setFamily(id: Int) {
        
        for fam in families {
            if fam.id == id {
                self.family = fam
            }
        }
        
    }
    
    func handleInfoResponse(response: Response) {
        
        if (response.content != nil) {
            
            firstName = response.content!["first-name"] as! String
            lastName = response.content!["last-name"] as! String

            let kidsResponse = response.content!["kids"] as! NSArray
            
            for kidObject in kidsResponse {
                
                kids.append(Link.unwrapKid(kidObject as! NSMutableDictionary))
                
            }
            
            let familyResponse = response.content!["families"] as! NSArray
            
            for familyObject in familyResponse {
                
                families.append(Link.unwrapFamily(familyObject as! NSMutableDictionary))
                
            }
            
            family = families[0]
            //or load from data
            
            updateMenuItems()
                        
        } else {
            
            println("No content")
            
        }
        
    }
    
    func handleInfoError(error: Error) {
        
        deauthenticate()
        Cocoon.user = nil
        
        Cocoon.pushMain()
        
    }
    
    func updateMenuItems() {
        
        Cocoon.menuItems = [];
        
        
        for kid in kids {
            Cocoon.menuItems.append(kid)
        }
        
       Cocoon.menuItems.append(Link(id: 0, type: "default", displayName: "Family"))
        
        for friend in friends {
            Cocoon.menuItems.append(friend)
        }
        
        Cocoon.menuItems.append(Link(id: 1, type: "default", displayName: "Friends"))
        
        for group in groups {
            Cocoon.menuItems.append(group)
        }
        
        Cocoon.menuItems.append(Link(id: 2, type: "default", displayName: "Groups"))

        Cocoon.menuItems.append(Link(id: 3, type: "default", displayName: "Settings"))
        Cocoon.menuItems.append(Link(id: 4, type: "default", displayName: "Invite"))
        
        Cocoon.reloadMenu()
    }
    
    func saveAuthentication() {
        
        Cocoon.keychain.mySetObject(authentication.accessToken, forKey:kSecValueData)
        Cocoon.keychain.writeToKeychain()
        NSUserDefaults.standardUserDefaults().setObject(authentication.username, forKey: "username")
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "authenticated")
        NSUserDefaults.standardUserDefaults().setBool(facebook, forKey: "facebook")
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
    func deauthenticate() {
        
        Cocoon.keychain.mySetObject("", forKey:kSecValueData)
        Cocoon.keychain.writeToKeychain()
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "username")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "authenticated")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "facebook")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        
    }
    
    struct Authentication {
        
        var username: String
        var accessToken: String
        
    }
    
}