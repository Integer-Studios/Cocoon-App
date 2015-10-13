//
//  Register1ViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/23/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class Register1ViewController: InputScrollView {

    @IBOutlet weak var addToken: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
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
        
        self.addTextField(lastName)
        self.addTextField(addToken)

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
        
        print("Server Error: \(error.errorCode)")
        
    }

}
