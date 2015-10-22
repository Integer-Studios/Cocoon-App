//
//  OfferTableViewController.swift
//  Cocoon
//
//  Created by Quinn Finney on 10/21/15.
//  Copyright © 2015 Integer Studios. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class OfferTableViewController: UITableViewController {
    
    var items : [DetailedLink] = []
    var routeObjects : [RouteObject] = []
    var initialRouteTime: NSTimeInterval?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        print(Cocoon.selectedEvent!.id)
        super.viewWillAppear(animated)
        requestData("/event/requests/", parameters: ["event": "\(Cocoon.selectedEvent!.id)"], debug: false)
        
    }
    
    func handleTableResponse(response: Response) {
        
        self.items.removeAll(keepCapacity: false)
        
        for requestObject in response.content!["requests"] as! NSArray {
            
            items.append(DetailedLink.unwrapRideRequest(requestObject as! NSMutableDictionary))
            
        }
        
        Cocoon.location!.retrieveCurrentLocation({
            self.locationUpdated()
        })
        
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

    
    func locationUpdated() {
        let eventDestination = CLLocationCoordinate2D(latitude: Cocoon.selectedEvent?.info[4] as! Double, longitude: Cocoon.selectedEvent?.info[5] as! Double)
        
        let eventAnnotation = MKPointAnnotation()
        eventAnnotation.title = Cocoon.selectedEvent?.info[0] as? String
        eventAnnotation.coordinate = eventDestination
        
        let routeObject = RouteObject(origin: MKMapItem.mapItemForCurrentLocation(), destination: MKMapItem(placemark: MKPlacemark(coordinate: eventDestination, addressDictionary: nil)), destinationAnnotation: eventAnnotation)
        
        routeObjects.append(routeObject)
        
        for link in items {
            
            let destination = CLLocationCoordinate2D(latitude: link.info[4] as! Double, longitude: link.info[5] as! Double)
            
            let annotation = MKPointAnnotation()
            annotation.title = link.info[2] as? String
            annotation.coordinate = destination
            
            let routeObject = RouteObject(origin: MKMapItem.mapItemForCurrentLocation(), destination: MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil)), destinationAnnotation: annotation)
            
            routeObjects.append(routeObject)
            
            var secondRoute = RouteObject(origin:  MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil)), destination: MKMapItem(placemark: MKPlacemark(coordinate: eventDestination, addressDictionary: nil)), destinationAnnotation: eventAnnotation)
            secondRoute.second = true
            
            routeObjects.append(secondRoute)

            
        }
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            
            self.route()
            
        }
        
    }
    
    func route() {
        
        let semaphore = dispatch_semaphore_create(0)
        
        var routes: [MKRoute] = []
        var annotations: [MKPointAnnotation] = []
        
        if (self.routeObjects.count != 0) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                
                for routeObject in self.routeObjects {
                    
                    let directionsRequest = MKDirectionsRequest()
                    directionsRequest.transportType = MKDirectionsTransportType.Automobile
                    directionsRequest.source = routeObject.origin
                    directionsRequest.destination = routeObject.destination
                    directionsRequest.requestsAlternateRoutes = false
                    
                    let directions = MKDirections(request: directionsRequest)
                    
                    directions.calculateDirectionsWithCompletionHandler({(response:
                        MKDirectionsResponse?, error: NSError?) in
                        
                        if error != nil {
                            
                            print("Route Error!")
                            return;
                            
                        } else {
                            
                            let route = response?.routes.first
                            routes.append(route!)
                            annotations.append(routeObject.destinationAnnotation)
                            
                            
                        }
                        
                        dispatch_semaphore_signal(semaphore)
                        
                    })
                    
                    
                    
                }
                
            })
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                
                var time: NSTimeInterval = 0.0
                var previous: NSTimeInterval = 0.0
                for (index, _) in self.routeObjects.enumerate() {
                    
                    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);    // Wait until one semaphore is ready to consume
                    dispatch_async(dispatch_get_main_queue(), {    // For each element, dispatch to the main queue to draw route and annotation corresponding to that
                        let route = routes[index]
                        
                        if (self.routeObjects[index].second) {
                            
                            let newTime = abs((previous + route.expectedTravelTime) - self.initialRouteTime!)
                            self.routeObjects[index - 1].estimatedTime = newTime.toETA()
                            
                        } else {
                            
                            self.routeObjects[index].estimatedTime = route.expectedTravelTime.toETA()
                            previous = route.expectedTravelTime
                            
                        }
                        
//                        print("\(self.routeObjects[index].estimatedTime!.hours) hours, \(self.routeObjects[index].estimatedTime!.minutes) minutes and \(self.routeObjects[index].estimatedTime!.seconds) seconds")
                        if (time == 0) {
                            
                            self.initialRouteTime = route.expectedTravelTime
                            
                        }
                        time += route.expectedTravelTime
                    })
                    
                }
                
//                var minutes = (60*floor((time/60)))
//                let seconds = time - minutes
//                minutes /= 60
//                
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.tableView.reloadData()
                    
                })
                
                
                
            })
            
            
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("offerCell", forIndexPath: indexPath) as! OfferRideCell
        
        let link = items[indexPath.row]
        
        cell.name?.text = link.info[2] as? String
        cell.city?.text = link.info[3] as? String
        cell.duration?.text = getDuration(indexPath.row)
        cell.parentVC = self

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        items[indexPath.row].open(self)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func getDuration(index: Int) -> String {
        //TODO stub function
        if (self.routeObjects.count > index) {
            return "+\(self.routeObjects[index].estimatedTime!.toMinutes()) min"
        } else {
            return "0 min"
        }
    }

    func requestData(request: String, parameters : Dictionary<String,String>, debug: Bool = false) {
        
        Cocoon.requestManager.sendRequest(request, parameters: parameters, debug: debug, responseHandler: handleTableResponse, errorHandler: handleTableError)
        
    }

}
