//
//  RegisterVehicleViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/25/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class RegisterVehicleViewController: InputScrollView {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var size: UITextField!
    @IBOutlet weak var typeSelector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        name.leftViewMode = UITextFieldViewMode.Always
        name.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        size.leftViewMode = UITextFieldViewMode.Always
        size.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addTextField(size)
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
    
    @IBAction func registerVehicle(sender: AnyObject) {
        
        let familyID = Cocoon.user?.family?.id
        let params: NSMutableDictionary = [ "name": name.text, "size": size.text]
        params["family"] = familyID
        params["type"] = typeSelector.titleForSegmentAtIndex(typeSelector.selectedSegmentIndex)
        Cocoon.requestManager.sendRequest("/family/vehicles/register/", parameters: params, responseHandler: handleRegisterResponse, errorHandler: handleRegisterError)

        
    }

    func handleRegisterResponse(response: Response) {
        
        self.navigationController!.popViewControllerAnimated(true)
        
    }
    
    func handleRegisterError(error: Error) {
        
        println("Vehicle Register Error")
        
    }
    
    override func scrollToField() {
        
        if (self.keyboardFrame != nil) {
            
            var aRect = self.view.frame;
            aRect.size.height -= self.keyboardFrame!.size.height;
            if (self.activeField!.tag == textFields.count) {
                var frame = CGRectMake(typeSelector.frame.origin.x, typeSelector.frame.origin.y, typeSelector.frame.size.width, typeSelector.frame.size.height + 20)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
