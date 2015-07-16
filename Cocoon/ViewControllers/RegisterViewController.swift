//
//  RegisterViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/22/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var retypePassword: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    var keyboardFrame: CGRect?

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
        
        self.scrollView.setContentOffset(CGPointZero, animated: false)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @IBAction func registerButton(sender: AnyObject) {
        
        register()
        
    }
    
    @IBAction func textFieldBeganEdit(sender: AnyObject) {
        
        

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
        
        //check password
        if password.text != retypePassword.text {
            println("Passwords don't match.")
            return
        }
        
        var requestURL = "/user/register/auth/"
        var params: NSMutableDictionary = ["register-email": email.text, "register-password": password.text.sha1(), "register-first-name": firstName.text, "register-last-name": lastName.text]
        
        if (Cocoon.facebook != nil) {
            
            requestURL = "/user/register/facebook/"
            params["register-facebook-id"] = Cocoon.facebook?.id
            params["register-facebook-token"] = Cocoon.facebook?.token
            
        }
        
        //send register request
        Cocoon.requestManager.sendRequest(requestURL, parameters: params, responseHandler: handleRegisterResponse, errorHandler: handleRegisterError)
        
        //maybe loading gif?
        
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let newTag = textField.tag + 1
        
        if (newTag > 5) {
            
            println("done")
            
            
        } else {
            
            var nextResponder: UIResponder? = textField.superview?.viewWithTag(newTag)
            if (nextResponder != nil) {
                
                nextResponder?.becomeFirstResponder()
                scrollToField()

            } else {
                
                textField.resignFirstResponder()
                
            }
            
        }
        
        return false;
        
    }
    
    func scrollToField() {
        var scrollY: CGFloat = 0

        if (password.isFirstResponder()) {
            
            scrollY = password.frame.origin.y - password.frame.size.height
            
        } else if (retypePassword.isFirstResponder()) {
            
            scrollY = retypePassword.frame.origin.y - retypePassword.frame.size.height
            
        } else if (firstName.isFirstResponder()){
            
            scrollY = firstName.frame.origin.y - firstName.frame.size.height
            
        } else if (lastName.isFirstResponder()){
            
            scrollY = lastName.frame.origin.y - lastName.frame.size.height
            
        } else if (email.isFirstResponder()){
            
            scrollY = email.frame.origin.y - email.frame.size.height
            
        }
        
        
//        if (self.keyboardFrame != nil) {
//            
//            var continueOff = self.continueButton.frame.origin.y + self.continueButton.frame.size.height
//            
//            if (continueOff - self.scrollView.contentOffset.y) > (self.scrollView.frame.size.height - self.keyboardFrame!.size.height) {
//                
//                scrollY = (self.scrollView.frame.size.height - (self.keyboardFrame!.size.height - 30))
//                
//            }
//            
//            
//        }
        
        let scrollPoint: CGPoint = CGPointMake(0.0, scrollY);
        self.scrollView.setContentOffset(scrollPoint, animated: true)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {

        let info:NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        self.keyboardFrame = keyboardSize
        scrollToField()
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        self.keyboardFrame = nil
        var scrollY: CGFloat = continueButton.frame.origin.y - (self.view.frame.size.height - 120)
        let scrollPoint: CGPoint = CGPointMake(0.0, scrollY);
        self.scrollView.setContentOffset(scrollPoint, animated: true)

    }

}
