//
//  InputScrollView.swift
//  Cocoon
//
//  Created by Quinn Finney on 7/21/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class InputScrollView: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var textFields: [UITextField] = [UITextField]()
    var keyboardFrame: CGRect?
    var singleTap: UITapGestureRecognizer?
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    func addTextField(textField: UITextField) {
        
        self.textFields.append(textField)
        
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
            
            print("done")
            
            
        } else {
            
            let nextResponder: UIResponder? = textField.superview?.viewWithTag(newTag)
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
            
            let aRect = self.view.frame;
            if (!CGRectContainsPoint(aRect, self.activeField!.frame.origin) ) {
                self.scrollView.scrollRectToVisible(activeField!.frame, animated:true)
            }
            
        }
        
    }
    
    func keyboardDidShow(notification: NSNotification) {
        
        let info:NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        self.keyboardFrame = keyboardSize
        if (self.activeField != nil) {
            self.scrollToField()
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        let contentInsets = UIEdgeInsetsZero;
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
