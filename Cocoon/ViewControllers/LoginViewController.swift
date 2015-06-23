//
//  LoginViewController.swift
//  Cocoon
//
//  Created by Quinn Finney on 6/22/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let keychain = KeychainWrapper()
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func login(sender: AnyObject) {
        
        let requestManager = RequestManager()
        requestManager.sendRequest("/user/login/", parameters: ["username": usernameField.text, "password": passwordField.text.sha1()], responseHandler: handleLoginResponse)
        
    }
    
    func handleLoginResponse(data: AnyObject?) {
        
        if let content = data as? [String: AnyObject] {
            
            if let token = content["access-token"] as? String {
                
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    
                    Cocoon.setRootViewController("navigation")
                    
                }
                
                println("The access token is: " + token)
                
                keychain.mySetObject(token, forKey:kSecValueData)
                keychain.writeToKeychain()
                NSUserDefaults.standardUserDefaults().setObject(usernameField.text, forKey: "username")
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "authenticated")
                NSUserDefaults.standardUserDefaults().synchronize()
                
            } else {
                
                println("Failed to parse access-token")
                
            }
            
        } else {
            
            println("Failed to parse login response")
            
        }
        
    }
        
}
