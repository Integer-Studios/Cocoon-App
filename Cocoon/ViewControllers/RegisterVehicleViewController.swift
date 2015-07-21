//
//  RegisterVehicleViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/25/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class RegisterVehicleViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var size: UITextField!
    @IBOutlet weak var typeSelector: UISegmentedControl!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
