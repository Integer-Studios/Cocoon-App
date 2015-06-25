//
//  RegisterKidViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/25/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class RegisterKidViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var genderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lastName.text = Cocoon.user?.family?.displayName
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerKid(sender: AnyObject) {
       
        let familyID = Cocoon.user?.family?.id
        let params: NSMutableDictionary = [ "first-name": firstName.text, "last-name": lastName.text, "age": age.text, "sex": genderSwitch.on]
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

    @IBAction func genderChange(sender: AnyObject) {

        if (genderSwitch.on) {
         
            genderLabel.text = "Male"
            
        } else {
            
            genderLabel.text = "Girl"
            
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
