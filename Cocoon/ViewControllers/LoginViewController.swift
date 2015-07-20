//
//  LoginViewController.swift
//  Cocoon
//
//  Created by Quinn Finney on 6/22/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    
    let keychain = KeychainWrapper()
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapCaptured:")
        self.view.addGestureRecognizer(singleTap)
        
        if (FBSDKAccessToken.currentAccessToken() != nil && Cocoon.user != nil) {
            // User is already logged in, do work such as go to next view controller.
            let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                if error == nil {

                    let userName : String = result.valueForKey("name") as! String
                    let firstName : String = result.valueForKey("first_name") as! String
                    let lastName : String = result.valueForKey("last_name") as! String
                    let userEmail : String = result.valueForKey("email") as! String
                    
                    Cocoon.facebook = Facebook(id: FBSDKAccessToken.currentAccessToken().userID, firstName: firstName, lastName: lastName, email: userEmail as String, token: FBSDKAccessToken.currentAccessToken().tokenString)
                    
                    Cocoon.requestManager.sendRequest("/user/facebook/login/", parameters: ["facebook-id": Cocoon.facebook!.id, "facebook-token": Cocoon.facebook!.token, "facebook-email": Cocoon.facebook!.email], responseHandler: self.handleFacebookLoginResponse, errorHandler: self.handleFacebookLoginError)
                    
                } else {
                    
                    println("graphrequest error")

                }
            })
            
        } else {
            
         
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func facebookLogin(sender: AnyObject) {
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            
            println("FACEBOOK LOGOUT")
            FBSDKLoginManager().logOut()
            
        } else {
            
        FBSDKLoginManager().logInWithReadPermissions(self.facebookReadPermissions, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            if error != nil {
                //According to Facebook:
                //Errors will rarely occur in the typical login flow because the login dialog
                //presented by Facebook via single sign on will guide the users to resolve any errors.
                
                // Process error
                println("FACEBOOK ERROR")
                FBSDKLoginManager().logOut()
            } else if result.isCancelled {
                // Handle cancellations
                println("FACEBOOK CANCEL")
                FBSDKLoginManager().logOut()
            } else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                var allPermsGranted = true
                
                if (!result.grantedPermissions.contains("email")) {
                    allPermsGranted = false
                }
                if (!result.grantedPermissions.contains("user_friends")) {
                    allPermsGranted = false
                }
                
                if allPermsGranted {
                    // Do work
                    let fbToken = result.token.tokenString
                    let fbUserID = result.token.userID

                    let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
                    graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                        
                        if ((error) != nil) {
                            // Process error
                            println("Error: \(error)")
                        } else {
                           
                            let userName : String = result.valueForKey("name") as! String
                            let firstName : String = result.valueForKey("first_name") as! String
                            let lastName : String = result.valueForKey("last_name") as! String
                            let userEmail : String = result.valueForKey("email") as! String
                            println(userName + " " + userEmail)
                        
                            Cocoon.facebook = Facebook(id: fbUserID, firstName: firstName, lastName: lastName, email: userEmail as String, token: FBSDKAccessToken.currentAccessToken().tokenString)
                            
                            Cocoon.requestManager.sendRequest("/user/facebook/login/", parameters: ["facebook-id": Cocoon.facebook!.id, "facebook-token": Cocoon.facebook!.token, "facebook-email": Cocoon.facebook!.email], responseHandler: self.handleFacebookLoginResponse, errorHandler: self.handleFacebookLoginError)
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
                Cocoon.pushMain()
                
            }
            
        }
        
    }
    
    func handleFacebookLoginError(error: Error) {
        
        if (error.errorCode == 401) {
            
            //email exists, not connected
            println("Email Exists")
            usernameField.text = error.content!["email"] as? String
            facebookButton.enabled = false
            facebookButton.hidden = true
            
            connectButton.enabled = true
            connectButton.hidden = false
            
//            facebookButton.highlighted = false
//            facebookButton.setTitle("Connect", forState: UIControlState.Normal)
//            facebookButton.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
//            facebookButton.addTarget(self, action: "facebookConnect:", forControlEvents: UIControlEvents.TouchUpInside)
            
        } else if (error.errorCode == 502) {
            
            //new user
            println("New User")
            performSegueWithIdentifier("registerPush", sender: nil)
            
        }
        
    }
    
   @IBAction func facebookConnect(sender: AnyObject) {
        
        println("connect")
    Cocoon.requestManager.sendRequest("/user/facebook/connect/", parameters: ["username": usernameField.text, "password": passwordField.text.sha1(), "facebook-id": FBSDKAccessToken.currentAccessToken().userID, "facebook-token": FBSDKAccessToken.currentAccessToken().tokenString], responseHandler: handleFacebookLoginResponse, errorHandler: handleConnectError)

    
    }
    
    func handleConnectError(error: Error) {
        
        println("Connect Failed: \(error.errorCode)")
        
    }
    
    @IBAction func login(sender: AnyObject) {
        
        Cocoon.requestManager.sendRequest("/user/login/auth/", parameters: ["username": usernameField.text, "password": passwordField.text.sha1()], responseHandler: handleLoginResponse, errorHandler: handleLoginError)
        
    }
    
    func handleLoginResponse(response: Response) {
        
        if response.content != nil {
        
            if let token = response.content!["access-token"] as? String {
                
                println("The access token is: " + token)
                
                Cocoon.user = User(username: usernameField.text, accessToken: token)
                Cocoon.user?.saveAuthentication()
                Cocoon.user?.loadInfo(nil)
                Cocoon.pushMain()
                
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
    
    func tapCaptured(gesture: UITapGestureRecognizer) {
        
        if (self.usernameField.isFirstResponder()) {
            
            self.usernameField.resignFirstResponder()
            
        } else if (self.passwordField.isFirstResponder()) {
            
            self.passwordField.resignFirstResponder()
            
        }
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let newTag = textField.tag + 1
        
        if (newTag > 2) {
            
            println("done")
            textField.resignFirstResponder()

            
        } else {
            
            var nextResponder: UIResponder? = textField.superview?.viewWithTag(newTag)
            if (nextResponder != nil) {
                
                nextResponder?.becomeFirstResponder()
                
            } else {
                
                textField.resignFirstResponder()
                
            }
            
        }
        
        return false;
        
    }
        
}
