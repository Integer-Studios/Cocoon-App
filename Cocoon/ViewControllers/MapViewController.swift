//
//  MapViewController.swift
//  Cocoon
//
//  Created by Quinn Finney on 7/21/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import CoreLocation
import AddressBook

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
   
    var routeObjects: [RouteObject] = []
    var userAnnotation: MKPointAnnotation?
    var loaded = false
    var eventCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (Cocoon.selectedEvent != nil) {
            
            eventCoordinate = CLLocationCoordinate2D(latitude: Cocoon.selectedEvent?.info[4] as! Double, longitude: Cocoon.selectedEvent?.info[5] as! Double)
            
        }
        
        Cocoon.location!.retrieveCurrentLocation({
            self.locationUpdated()
        })
        self.mapView.showsUserLocation = true
        
    }
    
    func location() {
        
        
        
    }
    
    func locationUpdated() {
    
        if loaded {
            return
        }
        loaded = true
        
        var role: NSObject? = Cocoon.selectedEvent?.info[3]
//        let request: NSMutableDictionary
        let offers: Array<NSMutableDictionary>
        switch (Cocoon.selectedEvent?.info[6] as! String) {
            
            case "offer":
                offers = role as! Array<NSMutableDictionary>
                var previous: NSMutableDictionary?
                for o in offers {
                    
                    let offer = o 
                    
                    let destination = CLLocationCoordinate2D(latitude: (offer["latitude"] as! NSString).doubleValue, longitude: (offer["longitude"] as! NSString).doubleValue)
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = offer["kid-display"] as? String
                    annotation.coordinate = destination
                   
                    let routeObject: RouteObject!
                    
                    if (previous == nil) {
                        
                        previous = offer
                        routeObject = RouteObject(origin: MKMapItem.mapItemForCurrentLocation(), destination: MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil)), destinationAnnotation: annotation)

                    } else {
                        
                        let previousDestination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (previous!["latitude"] as! NSString).doubleValue, longitude: (previous!["longitude"] as! NSString).doubleValue), addressDictionary: nil))
                        
                        routeObject = RouteObject(origin: previousDestination, destination: MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil)), destinationAnnotation: annotation)
                        previous = offer
                        
                    }
                    
                    routeObjects.append(routeObject)
                    
                }
                
                let annotation = MKPointAnnotation()
                annotation.title = Cocoon.selectedEvent?.info[0] as? String
                annotation.coordinate = self.eventCoordinate!
                
                let routeObject = RouteObject(origin: MKMapItem(placemark: MKPlacemark(coordinate: (routeObjects.last?.destination.placemark.coordinate)!, addressDictionary: nil)), destination: MKMapItem(placemark: MKPlacemark(coordinate: self.eventCoordinate!, addressDictionary: nil)), destinationAnnotation: annotation)
                
                routeObjects.append(routeObject)
                
                break;
            case "request":
                
                let annotation = MKPointAnnotation()
                annotation.title = Cocoon.selectedEvent?.info[0] as? String
                annotation.coordinate = self.eventCoordinate!
                
                let routeObject = RouteObject(origin: MKMapItem(placemark: MKPlacemark(coordinate: Cocoon.location!.currentLocation!.coordinate, addressDictionary: nil)), destination: MKMapItem(placemark: MKPlacemark(coordinate: self.eventCoordinate!, addressDictionary: nil)), destinationAnnotation: annotation)
                
                routeObjects.append(routeObject)
                
//                request = role as! NSMutableDictionary
                break;
            case "none":
                role = nil
                let annotation = MKPointAnnotation()
                annotation.title = Cocoon.selectedEvent?.info[0] as? String
                annotation.coordinate = self.eventCoordinate!
                
                let routeObject = RouteObject(origin: MKMapItem(placemark: MKPlacemark(coordinate: Cocoon.location!.currentLocation!.coordinate, addressDictionary: nil)), destination: MKMapItem(placemark: MKPlacemark(coordinate: self.eventCoordinate!, addressDictionary: nil)), destinationAnnotation: annotation)
                
                routeObjects.append(routeObject)
                break;
            default:
                role = nil
                break;
        }
        
        userAnnotation = MKPointAnnotation()
        userAnnotation!.title = "Current Location"
        userAnnotation!.coordinate = (Cocoon.location?.currentLocation?.coordinate)!
    
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
        
            self.route()
            
        }
        
    }
   
    
    func route() {
        
        let semaphore = dispatch_semaphore_create(0)
       
        var routes: [MKRoute] = []
        var annotations: [MKPointAnnotation] = []
        
        if (!self.routeObjects.isEmpty) {
        
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
                
                for (index, _) in self.routeObjects.enumerate() {
                    
                    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);    // Wait until one semaphore is ready to consume
                    dispatch_async(dispatch_get_main_queue(), {    // For each element, dispatch to the main queue to draw route and annotation corresponding to that  
                        let route = routes[index]
                        self.routeObjects[index].estimatedTime = route.expectedTravelTime.toETA()
                        
//                        print("\(self.routeObjects[index].estimatedTime!.hours) hours, \(self.routeObjects[index].estimatedTime!.minutes) minutes and \(self.routeObjects[index].estimatedTime!.seconds) seconds")
                        
                        time += route.expectedTravelTime
                        self.mapView.addOverlay(route.polyline)
                        self.mapView.addAnnotation(annotations[index])
                    })
                    
                }
                
//                var minutes = (60*floor((time/60)))
//                let seconds = time - minutes
//                minutes /= 60
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    annotations.append(self.userAnnotation!)
                    self.fitRegionToRoutes(annotations)
                    
                })
                
                
                
            })

            
        }
        
    }
    
    func fitRegionToRoutes(annotations: [MKPointAnnotation]) {
              
        self.mapView.showAnnotations(annotations, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay
        overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = UIColor.blueColor()
            renderer.lineWidth = 1.0
            return renderer
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


