//
//  LocationManager.swift
//  Cocoon
//
//  Created by Quinn Finney on 10/22/15.
//  Copyright © 2015 Integer Studios. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager! = CLLocationManager()
    var locationCallbacks: [() -> ()] = []
    
    var currentLocation: CLLocation?
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
    }
    
    func retrieveCurrentLocation(callback:(() -> ())){
        
        self.locationCallbacks.append(callback);
        
    }
    
    func callbackLoaded() {
        
        if currentLocation != nil {
            
            if !(Cocoon.user!.loaded) {
                
                Cocoon.user!.loadInfo({
                    
                    Cocoon.loadCallback!()
                    
                })
                
            }
            
        } 
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last
        
        if !(Cocoon.user!.loaded) && Cocoon.loadCallback != nil {
            
            Cocoon.user!.loadInfo({
                
                Cocoon.loadCallback!()
                
            })
            
        }
        
        for callback in locationCallbacks {
            
            callback()
            
        }
        
        self.locationCallbacks.removeAll()
        
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
    
}

struct RouteObject {
    
    var origin: MKMapItem
    var destination: MKMapItem
    var destinationAnnotation: MKPointAnnotation
    var estimatedTime: ETA?
    var second = false

    init (origin: MKMapItem, destination: MKMapItem, destinationAnnotation: MKPointAnnotation) {
        
        self.origin = origin
        self.destination = destination
        self.destinationAnnotation = destinationAnnotation
        self.estimatedTime = nil

    }
    
}

struct ETA {
    
    var time: Double
    var hours: Double
    var minutes: Double
    var seconds: Double
    
    func toMinutes() -> Double {
        
        return (60*floor((time/60))) / 60
        
    }
    
}

extension NSTimeInterval {
    
    func toETA() -> ETA {
        
        var minutes = (60*floor((self/60))) / 60
        let hours = (60*floor((minutes/60))) / 60
        minutes -= hours * 60
        let seconds = self - (minutes * 60)
        
        return ETA(time: self, hours: hours, minutes: minutes, seconds: seconds)
        
    }
    
}
