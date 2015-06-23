//
//  TodoViewController.swift
//  Cocoon
//
//  Created by Quinn Finney on 6/22/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let keychain = KeychainWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        return cell
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        keychain.mySetObject("", forKey:kSecValueData)
        keychain.writeToKeychain()
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "username")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "authenticated")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            
            var login = self.storyboard?.instantiateViewControllerWithIdentifier("login") as! LoginViewController
            
            UIApplication.sharedApplication().keyWindow!.rootViewController = login
            
        }
        
    }

}
