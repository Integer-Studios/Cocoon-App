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
        
        Cocoon.requestManager.sendRequest("/user/login/", parameters: ["username": usernameField.text, "password": passwordField.text.sha1()], responseHandler: handleLoginResponse)
        
    }
    
    func handleLoginResponse(data: NSMutableDictionary) {
        
        if let token = data["access-token"] as? String {
               
            NSOperationQueue.mainQueue().addOperationWithBlock {
                    
                Cocoon.setRootViewController("navigation")
                    
            }
                
            println("The access token is: " + token)
                
            Cocoon.user = User(username: usernameField.text, accessToken: token)
            Cocoon.user?.saveAuthentication()

        } else {
                
            println("Failed to parse access-token")
                
        }
        
    }
        
}
