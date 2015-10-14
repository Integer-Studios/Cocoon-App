//
//  RegisterKidViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/25/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class RegisterKidViewController: InputScrollView {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var genderSelector: UISegmentedControl!
    
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
        self.addTextField(age)
        self.addTextField(lastName)
        self.addTextField(firstName)
        
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
      
        var params: Dictionary<String, String> =  Dictionary<String, String>()
        params["first-name"] = firstName.text
        params["last-name"] = lastName.text
        params["age"] = age.text
        params["sex"] = "\((genderSelector.selectedSegmentIndex == 0))"
        params["family"] = "\(familyID)"
        Cocoon.requestManager.sendRequest("/kid/register/", parameters: params, responseHandler: handleKidRegisterResponse, errorHandler: handleKidRegisterError)

        
    }
    
    func handleKidRegisterResponse(response: Response) {
        
        Cocoon.user?.loadInfo(userInfoCallback)
       
    }
    
    func userInfoCallback() {
        
        self.navigationController!.popViewControllerAnimated(true)
        
    }
    
    func handleKidRegisterError(error: Error) {
        
        print("Kid Register Error")
        
    }
    
    override func scrollToField() {
        
        if (self.keyboardFrame != nil) {
            
            var aRect = self.view.frame;
            aRect.size.height -= self.keyboardFrame!.size.height;
            if (self.activeField!.tag == textFields.count) {
                let frame = CGRectMake(genderSelector.frame.origin.x, genderSelector.frame.origin.y, genderSelector.frame.size.width, genderSelector.frame.size.height + 20)
                self.scrollView.scrollRectToVisible(frame, animated:true)
                
            } else {
                if (!CGRectContainsPoint(aRect, self.activeField!.frame.origin) ) {
             
                    self.scrollView.scrollRectToVisible(activeField!.frame, animated:true)
            
                }
            }
            
        } else {
            
            let aRect = self.view.frame;
            if (!CGRectContainsPoint(aRect, self.activeField!.frame.origin) ) {
                self.scrollView.scrollRectToVisible(activeField!.frame, animated:true)
            }
            
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
