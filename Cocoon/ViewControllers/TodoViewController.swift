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

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todoCell", forIndexPath: indexPath) as! TodoCell
        cell.title?.text = "Fake Event"
        cell.kidName?.text = "Jimmy"
        cell.badgeLabel.text = "3"
        return cell
    }
    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let addressDict = [kABPersonAddressStreetKey as NSString: "39 Via Conocido",            kABPersonAddressCityKey: "San Clemente", kABPersonAddressStateKey: "CA",           kABPersonAddressZIPKey:  "92675"]
        
        let stringAddress = "\(addressDict[kABPersonAddressStreetKey]) \(addressDict[kABPersonAddressCityKey]) \(addressDict[kABPersonAddressStateKey]) \(addressDict[kABPersonAddressZIPKey]) "
        let mapViewController = self.storyboard?.instantiateViewControllerWithIdentifier("map") as! MapViewController
        mapViewController.addressString = stringAddress
        mapViewController.addressDict = addressDict
        
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
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        var offerRideAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Offer" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
//            let geoCoder = CLGeocoder()
//            
//            let addressString = "39 Via Conocido San Clemente CA 92675"
//            
//            geoCoder.geocodeAddressString(addressString, completionHandler:
//                {(placemarks: [AnyObject]!, error: NSError!) in
//                    
//                    if error != nil {
//                        println("Geocode failed with error: \(error.localizedDescription)")
//                    } else if placemarks.count > 0 {
//                        let placemark = placemarks[0] as! CLPlacemark
//                        let location = placemark.location
//                        Cocoon.coords = location.coordinate
//                        
//                        let addressDict = [kABPersonAddressStreetKey as NSString: "39 Via Conocido",
//                            kABPersonAddressCityKey: "San Clemente",
//                            kABPersonAddressStateKey: "CA",
//                            kABPersonAddressZIPKey:  "92675"]
//                        
//                        let place = MKPlacemark(coordinate: Cocoon.coords!,
//                            addressDictionary: addressDict)
//                        
//                        let mapItem = MKMapItem(placemark: place)
//                        
//                        Cocoon.destinationTest = mapItem
//                        
//                        (self.navigationController as! NavigationController).pushView("map")
//                        
//                    }
//            })
            
//            (self.navigationController as! NavigationController).pushView("offerRide")
            
        })
        
        offerRideAction.backgroundColor = UIColor(hue: 151/359, saturation: 75/100, brightness: 84/100, alpha: 1)
        
        var requestRideAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Request" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
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
