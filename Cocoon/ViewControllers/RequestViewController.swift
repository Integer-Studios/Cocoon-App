//
//  RequestViewController.swift
//  Cocoon
//
//  Created by Quinn Finney on 10/21/15.
//  Copyright © 2015 Integer Studios. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RequestViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITabBarDelegate {
    
    @IBOutlet weak var tabBar: UITabBar!;
    @IBOutlet weak var mapView: MKMapView!

    var locationManager: CLLocationManager! = CLLocationManager()
    var pointAnnotation: MKPointAnnotation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.delegate = self;

        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
    func setMapAddress() {
        
        let coord = CLLocationCoordinate2D(latitude: 34.427883, longitude: -119.874690)
        self.mapView.showsUserLocation = false
        self.mapView.setCenterCoordinate(coord, animated: true)
        
        if (pointAnnotation != nil) {
            self.mapView.removeAnnotation(self.pointAnnotation!)
            self.pointAnnotation = nil
        }
        self.pointAnnotation = MKPointAnnotation()
        self.pointAnnotation?.title = "Address"
        self.pointAnnotation?.coordinate = coord
        self.mapView.addAnnotation(self.pointAnnotation!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        

        if (item.tag == 1) {
            
            if (self.pointAnnotation != nil) {
                
                self.mapView.removeAnnotation(self.pointAnnotation!)
                self.pointAnnotation = nil
                
            }
            self.mapView.showsUserLocation = true
            self.locationManager?.startUpdatingLocation()
            
        } else {
        
            setMapAddress()
            
        }
        
        
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
