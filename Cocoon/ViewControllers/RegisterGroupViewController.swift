//
//  RegisterGroupViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/30/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class RegisterGroupViewController: UIViewController {

    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var addressName: UITextField!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var street2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        println("Group Register Success")
        Cocoon.user?.loadInfo(userInfoCallback)
        
    }
    
    func userInfoCallback() {
        
        self.navigationController!.popViewControllerAnimated(true)
        
    }
    
    
    func handleGroupRegisterError(error: Error) {
        
        println("Group Register Error")
        
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
