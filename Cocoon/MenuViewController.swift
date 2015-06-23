//
//  MenuViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/22/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        Cocoon.menuView = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Cocoon.user!.menuItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = Cocoon.user!.menuItems[indexPath.row].displayName

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let id = Cocoon.user!.menuItems[indexPath.row].id
        let type = Cocoon.user!.menuItems[indexPath.row].type
        let displayName = Cocoon.user!.menuItems[indexPath.row].displayName
        
        if type == "default" {
            
            performSegueWithIdentifier("push\(id)", sender: nil)
            
        } else if type == "kid" {
            //open kid with (id)
        }
    }

}
