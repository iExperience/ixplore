//
//  RecommendationsMapViewController.swift
//  iXplore
//
//  Created by Alexander Ge on 7/12/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class RecommendationsMapViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    let camera = GMSCameraPosition.cameraWithLatitude(-33.907181, longitude: 18.418592, zoom: 12)
    var mapView: GMSMapView?
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Setup Google Maps

        // Show user location
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        // The myLocation attribute of the mapView may be null
//        if let mylocation = mapView!.myLocation {
//            print("User's location: \(mylocation)")
//        }
//        else {
//            print("User's location is unknown")
//        }
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        self.view = mapView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            
            mapView!.myLocationEnabled = true
            mapView!.settings.myLocationButton = true
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        
        if let location = locations.first {
            
            mapView!.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            locationManager.stopUpdatingLocation()
        }
    }
    

}













