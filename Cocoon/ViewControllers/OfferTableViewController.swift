//
//  OfferTableViewController.swift
//  Cocoon
//
//  Created by Quinn Finney on 10/21/15.
//  Copyright © 2015 Integer Studios. All rights reserved.
//

import UIKit
import CoreLocation

class OfferTableViewController: UITableViewController {
    
    var items : [DetailedLink] = []
    var eventID  = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        requestData("/event/requests/", parameters: ["event": "\(eventID)"], debug: true)
        
    }
    
    func handleTableResponse(response: Response) {
        
        self.items.removeAll(keepCapacity: false)
        
        for requestObject in response.content!["requests"] as! NSArray {
            
            items.append(DetailedLink.unwrapRideRequest(requestObject as! NSMutableDictionary))
            
        }
        
        self.tableView.reloadData()
    }
    
    func handleTableError(error: Error) {
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("offerCell", forIndexPath: indexPath) as! OfferRideCell
        
        let link = items[indexPath.row]
        
        cell.name?.text = link.info[2] as? String
        cell.city?.text = link.info[3] as? String
        cell.duration?.text = getDuration(link)
        cell.parentVC = self

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        items[indexPath.row].open(self)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func getDuration(request: DetailedLink) -> String {
        //TODO stub function
        let loc = request.info[4] as? CLLocation
        print(loc?.coordinate.longitude)
        print(loc?.coordinate.latitude)
        return "5 min"
    }

    func requestData(request: String, parameters : Dictionary<String,String>, debug: Bool = false) {
        
        Cocoon.requestManager.sendRequest(request, parameters: parameters, debug: debug, responseHandler: handleTableResponse, errorHandler: handleTableError)
        
    }

}
