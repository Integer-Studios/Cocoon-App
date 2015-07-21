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
    
    var textFields: [UITextField] = []
    var activeField: UITextField?
    var singleTap: UITapGestureRecognizer?

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
        
        self.textFields.append(password)
        self.textFields.append(retypePassword)
        self.textFields.append(firstName)
        self.textFields.append(lastName)
        self.textFields.append(email)

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
    
    func initializeKeyboardScroll() {
        
        self.scrollView.setContentOffset(CGPointZero, animated: false)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

        
        self.singleTap = UITapGestureRecognizer(target: self, action: "tapCaptured:")
        self.scrollView.addGestureRecognizer(self.singleTap!)
        
    }
    
    func deinitializeKeyboardScroll() {
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)

        self.scrollView.removeGestureRecognizer(self.singleTap!)
        
    }
    
    func tapCaptured(gesture: UITapGestureRecognizer) {
        
        for textfield in textFields {
            
            if textfield.isFirstResponder() {
                
                textfield.resignFirstResponder()
                break
                
            }
            
        }
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.activeField = textField;
        self.scrollToField()
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
       
        activeField = nil
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let newTag = textField.tag + 1
        
        if (newTag > textFields.count) {
            
            println("done")
            
            
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
    
    func scrollToField() {
        
        if (self.keyboardFrame != nil) {
            
            var aRect = self.view.frame;
            aRect.size.height -= self.keyboardFrame!.size.height;
            if (!CGRectContainsPoint(aRect, self.activeField!.frame.origin) ) {
                self.scrollView.scrollRectToVisible(activeField!.frame, animated:true)
            }
            
        } else {
            
            var aRect = self.view.frame;
            if (!CGRectContainsPoint(aRect, self.activeField!.frame.origin) ) {
                self.scrollView.scrollRectToVisible(activeField!.frame, animated:true)
            }
            
        }
        
    }
    
    func keyboardDidShow(notification: NSNotification) {

        let info:NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        var contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        self.keyboardFrame = keyboardSize
        self.scrollToField()
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        var contentInsets = UIEdgeInsetsZero;
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        self.keyboardFrame = nil

    }

}
