//
//  RegisterGroupViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/30/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class RegisterGroupViewController: InputScrollView {

    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var addressName: UITextField!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var street2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        name.leftViewMode = UITextFieldViewMode.Always
        name.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        addressName.leftViewMode = UITextFieldViewMode.Always
        addressName.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        street.leftViewMode = UITextFieldViewMode.Always
        street.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        street2.leftViewMode = UITextFieldViewMode.Always
        street2.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        city.leftViewMode = UITextFieldViewMode.Always
        city.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        state.leftViewMode = UITextFieldViewMode.Always
        state.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        zipCode.leftViewMode = UITextFieldViewMode.Always
        zipCode.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addTextField(zipCode)
        self.addTextField(state)
        self.addTextField(city)
        self.addTextField(street2)
        self.addTextField(street)
        self.addTextField(addressName)
        self.addTextField(name)
        
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
    
    @IBAction func registerGroup(sender: AnyObject) {
        let params: NSMutableDictionary = ["name" : name.text, "address-name" : addressName.text, "street" : street.text, "street-two" : street2.text, "city" : city.text, "state" : state.text, "zipcode" : zipCode.text]
        
        Cocoon.requestManager.sendRequest("/group/register/", parameters: params, responseHandler: handleGroupRegisterResponse, errorHandler: handleGroupRegisterError)
    }
    
    func handleGroupRegisterResponse(response: Response) {
        
        print("Group Register Success")
        Cocoon.user?.loadInfo(userInfoCallback)
        
    }
    
    func userInfoCallback() {
        
        self.navigationController!.popViewControllerAnimated(true)
        
    }
    
    
    func handleGroupRegisterError(error: Error) {
        
        print("Group Register Error")
        
    }
    
    override func scrollToField() {
        
        if (self.keyboardFrame != nil) {
            
            var aRect = self.view.frame;
            aRect.size.height -= self.keyboardFrame!.size.height;
            if (self.activeField!.tag == textFields.count) {
                let frame = CGRectMake(continueButton.frame.origin.x, continueButton.frame.origin.y, continueButton.frame.size.width, continueButton.frame.size.height)
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
