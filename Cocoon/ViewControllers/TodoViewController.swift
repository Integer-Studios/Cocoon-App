//
//  TodoViewController.swift
//  Cocoon
//
//  Created by Quinn Finney on 6/22/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit
import AddressBook

class TodoViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        Cocoon.setLoadCallback({
            if self.revealViewController() != nil {
                self.menuButton.target = self.revealViewController()
                self.menuButton.action = "revealToggle:"
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            }
            
            self.tableView.reloadData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (Cocoon.user?.events.count)!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todoCell", forIndexPath: indexPath) as! TodoCell
        
        cell.title?.text = Cocoon.user!.events[indexPath.row].info[0] as? String
        cell.kidName?.text = Cocoon.user!.events[indexPath.row].info[1] as? String
        cell.badgeLabel.text = "3"
        
        return cell
    }
    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        Cocoon.selectedEvent = Cocoon.user?.events[indexPath.row]
        
        
        
        let mapViewController = self.storyboard?.instantiateViewControllerWithIdentifier("map") as! MapViewController
        
        (self.navigationController as! NavigationController).pushViewController(mapViewController, animated: true)
    
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("sectionHeader") as! DoubleTitleHeader
        
        cell.leftTitle.text = "Today"
        cell.rightTitle.text = "3:00pm - 5:00pm"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        let offerRideAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Offer" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            Cocoon.selectedEvent = Cocoon.user?.events[indexPath.row]
            (self.navigationController as! NavigationController).pushView("offerRide")
        })
        
        offerRideAction.backgroundColor = UIColor(hue: 151/359, saturation: 75/100, brightness: 84/100, alpha: 1)
        
        let requestRideAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Request" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            Cocoon.selectedEvent = Cocoon.user?.events[indexPath.row]
            (self.navigationController as! NavigationController).pushView("requestRide")
        })
        
        requestRideAction.backgroundColor = UIColor(hue: 0, saturation: 71/100, brightness: 100/100, alpha: 1)
        
        return [offerRideAction, requestRideAction]
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        Cocoon.user?.logout()
        Cocoon.user = nil;        
        
    }

}
