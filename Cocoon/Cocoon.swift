//
//  cocoon.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/22/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import Foundation
import MapKit

class Cocoon {
    
    static let keychain = KeychainWrapper()
    static let requestManager = RequestManager()
    static let responseManager = ResponseManager()
    static var facebook: Facebook?
    static var isAuthenticated = false
    static var user : User?
    static var menuItems : [Link] = []
    
    static func initializeApplication() {
        
        self.isAuthenticated = checkAuthentication()
        
        if self.isAuthenticated {
            
            let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as? String;
            let token = keychain.myObjectForKey("v_Data") as? String;
            user = User(username: username!, accessToken: token!);
            if (NSUserDefaults.standardUserDefaults().boolForKey("facebook")) {
                user?.facebook = true
                println("A")
            }
            user?.loadInfo(nil)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            pushMain()
            
        } else {
            
            pushLogin()
            
        }
        
    }
    
    static func pushMain() {
        setRootViewController("main")
    }
    
    static func pushLogin() {
        setRootViewController("login")
    }
    
    static func setRootViewController(identifier: String) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController = storyboard.instantiateViewControllerWithIdentifier(identifier) as! UIViewController
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = viewController
        
    }
    
    static func checkAuthentication() -> Bool {
        
        if NSUserDefaults.standardUserDefaults().boolForKey("authenticated") {
            
            return true
            
        } else {
            
            return false
            
        }
        
    }
    
    static func updateMenu() {
        
        menuItems = [];
        
        menuItems.append(Link(id: 0, type: "menu", displayName: "My Events"))
        menuItems.append(Link(id: 2, type: "menu", displayName: "My Friends"))
        menuItems.append(Link(id: 4, type: "menu", displayName: "Settings"))
        menuItems.append(Link(id: 5, type: "menu", displayName: "Invite A Friend"))
        
        for kid in user!.kids {
            menuItems.append(kid)
        }
        
        menuItems.append(Link(id: 1, type: "menu", displayName: "Family"))
        
        for group in user!.groups {
            menuItems.append(group)
        }
        
        menuItems.append(Link(id: 3, type: "menu", displayName: "Groups"))
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuView = storyboard.instantiateViewControllerWithIdentifier("menu") as! MenuViewController
        
    }
    
}

struct Facebook {
    
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var token: String
    
}
