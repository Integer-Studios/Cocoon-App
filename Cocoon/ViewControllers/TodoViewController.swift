//
//  TodoViewController.swift
//  Cocoon
//
//  Created by Quinn Finney on 6/22/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit
import MapKit
import AddressBook
import CoreLocation

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
        
        let geoCoder = CLGeocoder()
        
        let addressString = "39 Via Conocido San Clemente CA 92675"
        
        geoCoder.geocodeAddressString(addressString, completionHandler:
            {(placemarks: [AnyObject]!, error: NSError!) in
                
                if error != nil {
                    println("Geocode failed with error: \(error.localizedDescription)")
                } else if placemarks.count > 0 {
                    let placemark = placemarks[0] as! CLPlacemark
                    let location = placemark.location
                    Cocoon.coords = location.coordinate
                   
                    let addressDict = [kABPersonAddressStreetKey as NSString: "39 Via Conocido",
                        kABPersonAddressCityKey: "San Clemente",
                        kABPersonAddressStateKey: "CA",
                        kABPersonAddressZIPKey:  "92675"]
                    
                    let place = MKPlacemark(coordinate: Cocoon.coords!,
                        addressDictionary: addressDict)
                    
                    let mapItem = MKMapItem(placemark: place)
                    
                    Cocoon.destinationTest = mapItem
                    
                    (self.navigationController as! NavigationController).pushView("map")
                    
                }
        })
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        Cocoon.user?.logout()
        Cocoon.user = nil;        
        
    }

}
