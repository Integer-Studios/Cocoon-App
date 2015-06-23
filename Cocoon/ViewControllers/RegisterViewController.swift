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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                
                Cocoon.user = User(username: email.text, accessToken: token)

                
            } else {
                
                println("Failed to parse access-token")
                
            }
            
        } else {
            
            println("Failed to parse registration response")
        
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
