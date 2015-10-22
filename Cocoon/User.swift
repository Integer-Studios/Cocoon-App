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
    var events : [DetailedLink] = []
    
    var family : Link?
    
    let authentication: Authentication
    var firstName: String = ""
    var lastName: String = ""
    var facebook: Bool = false
    var infoCallback: (() -> ())?
    var loaded: Bool = false
    
    init (username: String, accessToken: String) {
        
        authentication = Authentication(username: username, accessToken: accessToken)
        
    }
    
    func loadInfo(callback:(() -> ())?) {
        
        loaded = true
        infoCallback = callback
        Cocoon.requestManager.sendRequest("/user/info/", parameters: ["latitude":"\(Cocoon.location!.currentLocation!.coordinate.latitude)", "longitude":"\(Cocoon.location!.currentLocation!.coordinate.longitude)"], debug: true, responseHandler: handleInfoResponse, errorHandler: handleInfoError)
        
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
            kids = [];
            families = [];
            let kidsResponse = response.content!["kids"] as! NSArray
            
            for kidObject in kidsResponse {
                
                kids.append(Link.unwrapKid(kidObject as! NSMutableDictionary))
                
            }
            
            if (response.content!["family"] is Bool) {
                
                deauthenticate()
                Cocoon.user = nil
                
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    
                    Cocoon.setRootViewController("login")
                    
                }
                
            } else {
            
                let familyResponse = response.content!["family"] as! NSMutableDictionary
                let eventResponse = familyResponse["events"] as! NSArray
                
                families.append(Link.unwrapFamily(familyResponse))
                
                for event in eventResponse {
                    
                    events.append(DetailedLink.unwrapEvent(event as! NSMutableDictionary))
                }
                
                family = families[0]
                //or load from data
            
                Cocoon.updateMenu()
            
                if (infoCallback != nil) {
                
                    infoCallback!()
                
                }
                
            }
            
        } else {
            
            print("No content")
            
        }
        
    }
    
    func handleInfoError(error: Error) {
        
        deauthenticate()
        Cocoon.user = nil
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            
            Cocoon.setRootViewController("login")
            
        }
        
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
    
    func logout() {
        
        if (self.facebook) {
            
            FBSDKLoginManager().logOut()
            Cocoon.requestManager.sendRequest("/user/facebook/logout/", parameters: ["":""],  responseHandler: handleLogoutResponse, errorHandler: handleLogoutError)
            
        } else {
            
            Cocoon.requestManager.sendRequest("/user/logout/", parameters: ["":""], responseHandler: handleLogoutResponse, errorHandler: handleLogoutError)
            
        }
        
        deauthenticate()
       
    }
    
    func handleLogoutResponse(response: Response) {
        
        Cocoon.user = nil;
        NSOperationQueue.mainQueue().addOperationWithBlock {
            
            Cocoon.setRootViewController("login")
            
        }
        
    }
    
    func handleLogoutError(error: Error) {
        
        print("logout error")
        Cocoon.user = nil;
        NSOperationQueue.mainQueue().addOperationWithBlock {
            
            Cocoon.setRootViewController("login")
            
        }
        
    }
    
    struct Authentication {
        
        var username: String
        var accessToken: String
        
    }
    
}