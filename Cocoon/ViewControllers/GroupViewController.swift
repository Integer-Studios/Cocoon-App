//
//  GroupViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 7/1/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class GroupViewController: UITableViewController {
    
//    
//    Outlets
//    
    
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
//    
//    Variables
//    
    
    var items : [DetailedLink] = []
    var id = -1
    var name = "Failed to load"
    var info = "Failed to load"
    var memberType = 7 /* admin */
    
//
//    Requests
//    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        Cocoon.requestManager.sendRequest("/group/info/", parameters: ["group": "\(id)"], responseHandler: handleInfoResponse, errorHandler: handleInfoError)
        Cocoon.requestManager.sendRequest("/group/events/", parameters: ["group": "\(id)"], responseHandler: handleEventListResponse, errorHandler: handleEventListError)
        
    }
    
//    
//    Response Handlers
//
    
    func handleInfoResponse(response: Response) {
        
        name = response.content!["name"] as! String
        info = response.content!["description"] as! String
        memberType = response.content!["membership"] as! Int
        
        nameLabel?.text = name
        infoLabel?.text = info
        
    }
    
    func handleInfoError(error: Error) {
        
        print("Error loading group info")
        
    }
    
    func handleEventListResponse(response: Response) {
        
        items.removeAll(keepCapacity: false)
        
        for eventObject in response.content!["events"] as! NSArray {

            items.append(DetailedLink.unwrapEvent(eventObject as! NSMutableDictionary))
            
        }
        
        self.tableView.reloadData()
        
    }
    
    func handleEventListError(error: Error) {
        
        print("Error loading group events")
        
    }
    
//    
//    Actions
//    
    
    
    @IBAction func actionButtonPressed(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewControllerWithIdentifier("admin") 
        let vc = nav.childViewControllers[0] as! AdminViewController
        vc.setGroup(self)
        presentViewController(nav, animated: true, completion: nil)
        
//        switch memberType {
//        case 7:
//            //admin page
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            var nav = storyboard.instantiateViewControllerWithIdentifier("admin") as! UIViewController
//            var vc = nav.childViewControllers[0] as! AdminViewController
//            vc.setGroup(self)
//            presentViewController(nav, animated: true, completion: nil)
//            break
//        case 0:
//            //leave group
//            break
//        case 1:
//            //join group
//            break
//        default:
//            break
//        }
        
    }
    
    @IBAction func close(sender: AnyObject) {
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    
//    Custom Methods
//    
    
    func setGroup(id: Int) {
        self.id = id
    }
    
//
//    UI Configuration
//
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //for the header
        return items.count
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        items[indexPath.row].open(self)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todoCell", forIndexPath: indexPath) as! TodoCell
        cell.title?.text = items[indexPath.row].info[0] as? String
        cell.kidName?.text = items[indexPath.row].info[1] as? String
        cell.badgeLabel.text = "3"
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("sectionHeader") as! DoubleTitleHeader
        
        cell.leftTitle.text = "Today"
        cell.rightTitle.text = "3:00pm - 5:00pm"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        let offerRideAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Offer" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            
        })
        
        offerRideAction.backgroundColor = UIColor(hue: 151/359, saturation: 75/100, brightness: 84/100, alpha: 1)
        
        let requestRideAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Request" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            
        })
        
        requestRideAction.backgroundColor = UIColor(hue: 0, saturation: 71/100, brightness: 100/100, alpha: 1)
        
        return [offerRideAction, requestRideAction]
    }
    

}
