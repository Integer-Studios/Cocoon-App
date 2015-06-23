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
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: AnyObject) {
        
        Cocoon.requestManager.sendRequest("/user/login/", parameters: ["username": usernameField.text, "password": passwordField.text.sha1()], responseHandler: handleLoginResponse)
        
    }
    
    func handleLoginResponse(data: AnyObject?) {
        
        if let content = data as? [String: AnyObject] {
            
            if let token = content["access-token"] as? String {
               
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    
                    Cocoon.setRootViewController("navigation")
                    
                }
                println("The access token is: " + token)
                
                Cocoon.user = User(username: usernameField.text, accessToken: token)
                Cocoon.user?.saveAuthentication()

            } else {
                
                println("Login Failed")
                
            }
            
        } else {
            
            println("Login Failed 2")
            
        }
        
    }
        
}
