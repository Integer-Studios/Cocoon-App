//
//  RegisterKidViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/25/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class RegisterKidViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var genderSelector: UISegmentedControl!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var textFields: [UITextField] = [UITextField]()
    var keyboardFrame: CGRect?
    var singleTap: UITapGestureRecognizer?
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lastName.text = Cocoon.user?.family?.displayName
        age.leftViewMode = UITextFieldViewMode.Always
        age.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        lastName.leftViewMode = UITextFieldViewMode.Always
        lastName.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        firstName.leftViewMode = UITextFieldViewMode.Always
        firstName.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.textFields.append(age)
        self.textFields.append(lastName)
        self.textFields.append(firstName)
        
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
    
    @IBAction func registerKid(sender: AnyObject) {
       
        let familyID = Cocoon.user?.family?.id
        let params: NSMutableDictionary = [ "first-name": firstName.text, "last-name": lastName.text, "age": age.text, "sex": (genderSelector.selectedSegmentIndex == 0)]
        params["family"] = familyID
        Cocoon.requestManager.sendRequest("/kid/register/", parameters: params, responseHandler: handleKidRegisterResponse, errorHandler: handleKidRegisterError)

        
    }
    
    func handleKidRegisterResponse(response: Response) {
        
        Cocoon.user?.loadInfo(userInfoCallback)
       
    }
    
    func userInfoCallback() {
        
        self.navigationController!.popViewControllerAnimated(true)
        
    }
    
    func handleKidRegisterError(error: Error) {
        
        println("Kid Register Error")
        
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
            if (self.activeField!.tag == textFields.count) {
                var frame = CGRectMake(genderSelector.frame.origin.x, genderSelector.frame.origin.y, genderSelector.frame.size.width, genderSelector.frame.size.height + 20)
                self.scrollView.scrollRectToVisible(frame, animated:true)
                
            } else {
                if (!CGRectContainsPoint(aRect, self.activeField!.frame.origin) ) {
             
                    self.scrollView.scrollRectToVisible(activeField!.frame, animated:true)
            
                }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
