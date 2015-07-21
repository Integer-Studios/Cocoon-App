//
//  RegisterViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/22/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class RegisterViewController: InputScrollView {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var retypePassword: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var continueButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (Cocoon.facebook != nil) {
            
            email.text = Cocoon.facebook?.email
            firstName.text = Cocoon.facebook?.firstName
            lastName.text = Cocoon.facebook?.lastName
            
        }
        
        firstName.leftViewMode = UITextFieldViewMode.Always
        firstName.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        lastName.leftViewMode = UITextFieldViewMode.Always
        lastName.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        email.leftViewMode = UITextFieldViewMode.Always
        email.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        password.leftViewMode = UITextFieldViewMode.Always
        password.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        retypePassword.leftViewMode = UITextFieldViewMode.Always
        retypePassword.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addTextField(password)
        self.addTextField(retypePassword)
        self.addTextField(firstName)
        self.addTextField(lastName)
        self.addTextField(email)

        self.initializeKeyboardScroll()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.textFields = [UITextField]()
        
        self.deinitializeKeyboardScroll();
    
    }
    
    @IBAction func registerButton(sender: AnyObject) {
        
        register()
        
    }
    
    @IBAction func cancelRegistration(sender: AnyObject) {
        
        Cocoon.facebook = nil
        
        firstName.text = ""
        lastName.text = ""
        email.text = ""
        password.text = ""
        retypePassword.text = ""
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func register() {
        
        (self.navigationController as! NavigationController).pushView("register.1")
//        //check password
//        if password.text != retypePassword.text {
//            println("Passwords don't match.")
//            return
//        }
//        
//        var requestURL = "/user/register/auth/"
//        var params: NSMutableDictionary = ["register-email": email.text, "register-password": password.text.sha1(), "register-first-name": firstName.text, "register-last-name": lastName.text]
//        
//        if (Cocoon.facebook != nil) {
//            
//            requestURL = "/user/register/facebook/"
//            params["register-facebook-id"] = Cocoon.facebook?.id
//            params["register-facebook-token"] = Cocoon.facebook?.token
//            
//        }
//        
//        //send register request
//        Cocoon.requestManager.sendRequest(requestURL, parameters: params, responseHandler: handleRegisterResponse, errorHandler: handleRegisterError)
//        
//        //maybe loading gif?
        
    }
    
    func handleRegisterResponse(response: Response) {
        
        if response.content != nil {
           
            let token = response.content!["access-token"] as! String;
            println("The access token is: " + token)
            
            Cocoon.user = User(username: email.text, accessToken: token)
            Cocoon.user?.firstName = firstName.text
            Cocoon.user?.lastName = lastName.text
            Cocoon.user?.saveAuthentication()

            (self.navigationController as! NavigationController).pushView("register.1")
            
            
        } else {
            
            println("Failed to parse access-token")
            
        }
        
    }
    
    func handleRegisterError(error: Error) {
        
        println("Failed to register: \(error.errorCode)")
        
    }
    
}
