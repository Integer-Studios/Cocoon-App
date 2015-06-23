//
//  RegisterViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/22/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var retypePassword: UITextField!
    @IBOutlet weak var name: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func register(sender: AnyObject) {
        
        //check password
        if password.text != retypePassword.text {
            println("Passwords don't match.")
            return
        }
        
        //send register request
        Cocoon.requestManager.sendRequest("/user/register/", parameters: ["register-email": email.text, "register-password": password.text.sha1(), "register-name": name.text], responseHandler: handleRegisterResponse)
    }
    
    func handleRegisterResponse(data: NSMutableDictionary) {
        
        if let token = data["access-token"] as? String {
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                
                Cocoon.setRootViewController("navigation")
                
            }
            
            println("The access token is: " + token)
            
            Cocoon.user = User(username: email.text, accessToken: token)
            Cocoon.user?.saveAuthentication()
            
        } else {
            
            println("Failed to parse access-token")
            
        }
        
    }

}
