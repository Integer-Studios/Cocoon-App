//
//  Register1ViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/23/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class Register1ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addToken: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    var keyboardFrame: CGRect?
    
    var textFields: [UITextField] = []
    var activeField: UITextField?
    
    var singleTap: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        lastName.text = Cocoon.user?.lastName
        // Do any additional setup after loading the view.
        lastName.text = ""
        self.navigationItem.hidesBackButton = true;
        addToken.leftViewMode = UITextFieldViewMode.Always
        addToken.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        lastName.leftViewMode = UITextFieldViewMode.Always
        lastName.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textFields.append(lastName)
        self.textFields.append(addToken)

        self.initializeKeyboardScroll()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.textFields = [UITextField]()
        
        self.deinitializeKeyboardScroll();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeKeyboardScroll() {
        
        self.scrollView.setContentOffset(CGPointZero, animated: false)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
       
        self.singleTap = UITapGestureRecognizer(target: self, action: "tapCaptured:")
        
        self.scrollView.addGestureRecognizer(singleTap!)
        
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
        if (self.activeField != nil) {
            self.scrollToField()
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        var contentInsets = UIEdgeInsetsZero;
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        self.keyboardFrame = nil
        
    }
    
    @IBAction func `continue`(sender: AnyObject) {
        
        (self.navigationController as! NavigationController).pushView("register.2")
//
//        if addToken.text.isEmpty && !lastName.text.isEmpty {
//            
//            Cocoon.requestManager.sendRequest("/family/register/", parameters: ["name": lastName.text, "relationship": "father"], responseHandler: handleFamilyRegisterResponse, errorHandler: handleFamilyRegisterError)
//            
//        } else {
//            
//            Cocoon.requestManager.sendRequest("/family/confirm/", parameters: ["add-token": addToken.text], responseHandler: handleFamilyRegisterResponse, errorHandler: handleFamilyRegisterError)
//            
//        }
//        
    }
    
    func handleFamilyRegisterResponse(response: Response) {
        
        Cocoon.user?.loadInfo(nil)
        Cocoon.pushMain()
        
    }
    
    func handleFamilyRegisterError(error: Error) {
        
        println("Server Error: \(error.errorCode)")
        
    }

}
