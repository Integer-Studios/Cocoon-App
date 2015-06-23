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
    
    let keychain = KeychainWrapper()

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
        let requestManager = RequestManager()
        requestManager.sendRequest("/user/register/", parameters: ["register-email": email.text, "register-password": password.text.sha1(), "register-name": name.text], responseHandler: handleRegisterResponse)
        
    }
    
    func handleRegisterResponse(data: AnyObject?) {
        
        if let content = data as? [String: AnyObject] {
            
            if let token = content["access-token"] as? String {
                
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    
                    Cocoon.setRootViewController("navigation")
                    
                }
                
                keychain.mySetObject(token, forKey:kSecValueData)
                keychain.writeToKeychain()
                NSUserDefaults.standardUserDefaults().setObject(email.text, forKey: "username")
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "authenticated")
                NSUserDefaults.standardUserDefaults().synchronize()
                
            } else {
                
                println("Failed to parse access-token")
                
            }
            
        } else {
            
            println("Failed to parse registration response")
        
        }
    }

}
