//
//  Register2ViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/23/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class Register2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginTokenReceived:", name: "ReceivedAuthToken", object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func connectSycamore(sender: AnyObject) {
        
        var userType = 3
        
        //Get the appropriate scopes to request
        var scopes: String;
        switch (userType) {
        case 1: //student
            
            scopes = SycamoreConstants.kStudentScopes.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            break;
        case 2: //family
            scopes = SycamoreConstants.kFamilyScopes.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            break;
        case 3: //teacher
            scopes = SycamoreConstants.kEmployeeScopes.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            break;
        default:
            scopes = SycamoreConstants.kFamilyScopes.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        }
        
        var encodedCallback = SycamoreConstants.kCallbackURI.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var authURL: NSURL = NSURL(string: SycamoreConstants.kAuthURL(scopes, encoded_callback: encodedCallback))!
        
        UIApplication.sharedApplication().openURL(authURL);
        
    }

    func loginTokenReceived(notification: NSNotification) {
        
        println("Received")
        var userInfo = notification.userInfo as! [NSString : NSString]
        var returnedURL: NSString = userInfo["Returned_URL"]!
        
        println(returnedURL)
        
    }
    
}
