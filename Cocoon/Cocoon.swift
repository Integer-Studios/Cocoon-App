//
//  cocoon.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/22/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import Foundation

class Cocoon {
    
    static let keychain = KeychainWrapper()
    static var isAuthenticated = false
    static var user : User?
    
    static func determineInitialView() {
        
        self.isAuthenticated = checkAuthentication()
        
        if self.isAuthenticated {
            
            setRootViewController("navigation")
            
        } else {
            
            setRootViewController("login")
            
        }
    }
    
    static func setRootViewController(identifier: String) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController = storyboard.instantiateViewControllerWithIdentifier(identifier) as! UIViewController
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = viewController
        
    }
    
    static func checkAuthentication() -> Bool {
        
        if NSUserDefaults.standardUserDefaults().boolForKey("authenticated") {
            
            println(keychain.myObjectForKey("v_Data") as? String)
            return true
            
        } else {
            
            return false
            
        }
        
    }
    
}