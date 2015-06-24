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
    @IBOutlet weak var facebookButton: UIButton!
    
    let keychain = KeychainWrapper()
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]

    override func viewDidLoad() {
        super.viewDidLoad()
        println("Z")
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // User is already logged in, do work such as go to next view controller.
            println("C")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func facebookLogin(sender: AnyObject) {

        FBSDKLoginManager().logInWithReadPermissions(self.facebookReadPermissions, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            if error != nil {
                //According to Facebook:
                //Errors will rarely occur in the typical login flow because the login dialog
                //presented by Facebook via single sign on will guide the users to resolve any errors.
                
                // Process error
                FBSDKLoginManager().logOut()
            } else if result.isCancelled {
                // Handle cancellations
                FBSDKLoginManager().logOut()
                println("A")
            } else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                var allPermsGranted = true
                
                if (!result.grantedPermissions.contains("email")) {
                    allPermsGranted = false
                }
                
                if allPermsGranted {
                    // Do work
                    let fbToken = result.token.tokenString
                    let fbUserID = result.token.userID
                    
                    let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
                    graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                        
                        if ((error) != nil)
                        {
                            // Process error
                            println("Error: \(error)")
                        }
                        else {
                           
                            let userName : NSString = result.valueForKey("name") as! NSString
                            let firstName = (userName as String).componentsSeparatedByString(" ").first
                            let lastName = (userName as String).componentsSeparatedByString(" ").last
                            let userEmail : NSString = result.valueForKey("email") as! NSString
                            println(fbToken)
                            Cocoon.facebook = Facebook(id: fbUserID, firstName: firstName!, lastName: lastName!, email: userEmail as String, token: fbToken)
                            
                            Cocoon.requestManager.sendRequest("/user/facebook/", parameters: ["facebook-id": fbUserID, "facebook-token": fbToken, "facebook-email": userEmail], responseHandler: self.handleFacebookLoginResponse, errorHandler: self.handleFacebookLoginError)
                        }
                    })
                    
                    
                } else {
                    //The user did not grant all permissions requested
                    //Discover which permissions are granted
                    //and if you can live without the declined ones
                    
                }
            }
        })
        
    }
    
    func handleFacebookLoginResponse(response: Response) {
        
        if (response.content != nil) {
            let facebookID = response.content!["facebook-id"] as? String
            let facebookToken = response.content!["facebook-token"] as? String;
            
            if (facebookID != nil && facebookToken != nil) {

                //logged in
                Cocoon.user = User(username: facebookID!, accessToken: facebookToken!)
                Cocoon.user?.facebook = true;
                Cocoon.user?.saveAuthentication()
                
            }
            
        }
        
    }
    
    func handleFacebookLoginError(error: Error) {
        
        if (error.errorCode == 401) {
            
            //email exists, not connected
            println("Email Exists")
            usernameField.text = error.content!["email"] as? String
            facebookButton.highlighted = false
            facebookButton.setTitle("Connect", forState: UIControlState.Normal)
            facebookButton.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
            facebookButton.addTarget(self, action: "facebookConnect:", forControlEvents: UIControlEvents.TouchUpInside)
            
        } else if (error.errorCode == 501) {
            
            //new user
            println("New User")
            performSegueWithIdentifier("registerPush", sender: nil)
            
        }
        
    }
    
   @IBAction func facebookConnect(sender: AnyObject) {
        
        println("connect")
        
    }
     
    @IBAction func login(sender: AnyObject) {
        
        Cocoon.requestManager.sendRequest("/user/login/auth/", parameters: ["username": usernameField.text, "password": passwordField.text.sha1()], responseHandler: handleLoginResponse, errorHandler: handleLoginError)
        
    }
    
    func handleLoginResponse(response: Response) {
        
        if response.content != nil {
        
            if let token = response.content!["access-token"] as? String {
        
                Cocoon.setRootViewController("main")
                
                println("The access token is: " + token)
                
                Cocoon.user = User(username: usernameField.text, accessToken: token)
                Cocoon.user?.saveAuthentication()
                Cocoon.user?.loadInfo()
                
            } else {
                
                println("Failed to parse access-token")
                
            }
            
        } else {
            
            println("No Token Received")
            
        }
        
    }
    
    func handleLoginError(error: Error) {

        println("Login Failed: \(error.errorCode)")
        
    }
        
}
