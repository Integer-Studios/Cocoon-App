//
//  MenuViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/22/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if Cocoon.menuItems.count > 0 {
            return 3
        } else {
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 4
        case 1:
            return findAmountOf("kid") + 1
        case 2:
            return findAmountOf("group") + 1
        default:
            return 0
        }
        
    }
    
    func findAmountOf(type: String) -> Int {
        var count = 0
        for i in Cocoon.menuItems {
            
            if i.type == type {
                count = count + 1
            }
            
        }
        return count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var offset = 0
       
        switch indexPath.section {
        case 1:
            offset += 4
            break
        case 2:
            offset += 5
            offset += findAmountOf("kid")
            break
        default:
            break
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as! IconCell
        
        cell.displayName?.text = Cocoon.menuItems[indexPath.row + offset].displayName
        
        let image : UIImage = UIImage(named:"menu.png")!
        cell.iconImage?.image = image

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let offset = indexPath.section * 4
        Cocoon.menuItems[indexPath.row + offset].open(self)
        
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("sectionHeader") as! SingleTitleHeader
        
        switch (section) {
        case 0:
            cell.displayName?.text = "Me"
            break
        case 1:
            cell.displayName?.text = "Family"
            break
        case 2:
            cell.displayName?.text = "Groups"
            break
        default:
            cell.displayName?.text = "Unknown"
            break
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }

}
