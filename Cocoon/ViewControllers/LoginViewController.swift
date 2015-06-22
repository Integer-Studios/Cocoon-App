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
        
        let requestManager = RequestManager()
        requestManager.sendRequest("/user/login/", parameters: ["username": usernameField.text, "password": passwordField.text.sha1()], responseHandler: handleLoginResponse)
        
    }
    
    func handleLoginResponse(data: ResponseData) {
        
        if let content = data.toDictionary() {
            
            if let token = content["access-token"] as? ResponseData {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    
                    var navigation = self.storyboard?.instantiateViewControllerWithIdentifier("navigation") as! NavigationViewController
                    
                    UIApplication.sharedApplication().keyWindow!.rootViewController = navigation
                    
                }
                println("The access token is: " + token.toString()!)
                
            } else {
                
                println("Login Failed")
                
            }
            
        } else {
            
            println("Login Failed 2")
            
        }
        
    }
        
}
