//
//  Register1ViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/23/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class Register1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func newFamily(sender: AnyObject) {
        
        //register family request
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            
            Cocoon.setRootViewController("navigation")
            
        }
    }

    @IBAction func existingFamily(sender: AnyObject) {
        
        //existing family stuff?
        
        (self.navigationController as! NavigationController).pushView("register2")
        
    }

}
