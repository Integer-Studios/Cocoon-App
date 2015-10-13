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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var destination: MKMapItem?
    var locations: [MKMapItem] = [MKMapItem]()
    var locationManager: CLLocationManager!
    var addressString: String?
    var addressDict: [NSObject : AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let geoCoder = CLGeocoder()
        let geoCoder1 = CLGeocoder()
        let geoCoder2 = CLGeocoder()

        let addressDictDest1 = [kABPersonAddressStreetKey as NSString: "18 Courte Jaime",            kABPersonAddressCityKey: "San Clemente", kABPersonAddressStateKey: "CA",           kABPersonAddressZIPKey:  "92675"]
        let addressDictDest2 = [kABPersonAddressStreetKey as NSString: "15 Calle Careyes",            kABPersonAddressCityKey: "San Clemente", kABPersonAddressStateKey: "CA",           kABPersonAddressZIPKey:  "92675"]
        let stringAddress1 = "\(addressDictDest1[kABPersonAddressStreetKey]) \(addressDictDest1[kABPersonAddressCityKey]) \(addressDictDest1[kABPersonAddressStateKey]) \(addressDictDest1[kABPersonAddressZIPKey]) "
        let stringAddress2 = "\(addressDictDest2[kABPersonAddressStreetKey]) \(addressDictDest2[kABPersonAddressCityKey]) \(addressDictDest2[kABPersonAddressStateKey]) \(addressDictDest2[kABPersonAddressZIPKey]) "

        geoCoder.geocodeAddressString(self.addressString!, completionHandler:
            {(placemarks: [AnyObject]!, error: NSError!) in
                
                if error != nil {
                    print("Geocode failed with error: \(error.localizedDescription)")
                } else if placemarks.count > 0 {
                    let placemark = placemarks[0] as! CLPlacemark
                    let location = placemark.location
                    let coords = location.coordinate
                    
                    
                    let place = MKPlacemark(coordinate: coords,
                        addressDictionary: self.addressDict!)
                    
                    let mapItem = MKMapItem(placemark: place)
                    
                    self.destination = mapItem
                    self.addressFound()
                }
        })
        geoCoder1.geocodeAddressString(stringAddress1, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) in
            
            if error != nil {
                print("Geocode failed with error: \(error.localizedDescription)")
            } else if placemarks.count > 0 {
                let placemark = placemarks[0] as! CLPlacemark
                let location = placemark.location
                let coords = location.coordinate
                
                
                let place = MKPlacemark(coordinate: coords,
                    addressDictionary: addressDictDest2)
                
                let mapItem = MKMapItem(placemark: place)
                
                self.locations.append(mapItem)
                self.addressFound()
            }
        })

        geoCoder2.geocodeAddressString(stringAddress2, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) in
            
            if error != nil {
                print("Geocode failed with error: \(error.localizedDescription)")
            } else if placemarks.count > 0 {
                let placemark = placemarks[0] as! CLPlacemark
                let location = placemark.location
                let coords = location.coordinate
                
                
                let place = MKPlacemark(coordinate: coords,
                    addressDictionary: addressDictDest2)
                
                let mapItem = MKMapItem(placemark: place)
                
                self.locations.append(mapItem)
                self.addressFound()
            }
        })

        locationManager = CLLocationManager()
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addressFound() {
        
        print(locations.count)
        if (locations.count == 2) {
            
            self.getDirections()
            
        }
        
    }
    
    func getDirections() {
        
        let request = MKDirectionsRequest()
//        request.setSource(MKMapItem.mapItemForCurrentLocation())
        request.setSource = locations[0]
        request.setDestination = destination!
        request.requestsAlternateRoutes = false
        
        let destinationLocation = destination!.placemark.location
        let latitudeDest = destination!.placemark.location.coordinate.latitude
        let longitudeDest = destination!.placemark.location.coordinate.latitude

        let sourceLocation = locations[0].placemark.location
        let latitudeSource = locations[0].placemark.location.coordinate.latitude
        let longitudeSource = locations[0].placemark.location.coordinate.latitude

        print(sourceLocation.distanceFromLocation(destinationLocation))
        
        print("DEST: X: \(latitudeDest) Y: \(longitudeDest)")
        print("SOUC: X: \(latitudeSource) Y: \(longitudeSource)")

        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler({(response:
            MKDirectionsResponse!, error: NSError!) in
            
            if error != nil {
                print("Error getting directions")
            } else {
                self.showRoute(response)
            }
            
        })
        
    }
    
    func showRoute(response: MKDirectionsResponse) {
        
        for route in response.routes {
            
            mapView.addOverlay(route.polyline,
                level: MKOverlayLevel.AboveRoads)
            
            for step in route.steps {
                print(step.instructions)
            }
        }
        let userLocation = mapView.userLocation
        
//        if (destination?.placemark.coordinate != nil && userLocation != nil) {
//            let distanceY = abs(locations[0].placemark.location.coordinate.longitude - destination!.placemark.coordinate.longitude) * 2.2;
//            let distanceX = abs(locations[0].placemark.location.coordinate.longitude - destination!.placemark.coordinate.latitude) * 2.2;
//        
//            let span = MKCoordinateSpanMake(distanceX, distanceY)
//        
//            let region = MKCoordinateRegionMake(destination!.placemark.coordinate, span)
//            
//            mapView.setRegion(region, animated: true)
//        
//        } else {
        
            let region = MKCoordinateRegionMakeWithDistance(destination!.placemark.coordinate, 1, 1)
            
            mapView.setRegion(region, animated: true)
            
//        }
    
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = UIColor.blueColor()
            renderer.lineWidth = 5.0
        return renderer
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        
//        self.mapView.setRegion(region, animated: true)
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
