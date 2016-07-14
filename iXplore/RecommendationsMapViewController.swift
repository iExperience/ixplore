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
    
    // button layout outlets
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var listButton: UIButton!
    
    // to get user location
    let locationManager = CLLocationManager()
    
    // position the map over workshop 17
    var camera: GMSCameraPosition?
    var mapView: GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Show user location
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        // Setup Google Maps
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if locationManager.location != nil {
            
            camera = GMSCameraPosition.cameraWithLatitude((locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 14)
        }
        else {
            
            camera = GMSCameraPosition.cameraWithLatitude(-33.907181, longitude: 18.418592, zoom: 3)
        }
        let mapFrame = CGRectMake(0, 0, appDelegate.window!.frame.width, appDelegate.window!.frame.height)
        mapView = GMSMapView.mapWithFrame(mapFrame, camera: camera!)
        
        // test marker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        self.view.addSubview(mapView!)
        
        self.view.bringSubviewToFront(menuButton)
        self.view.bringSubviewToFront(searchField)
        
        listButton.layer.cornerRadius = 5
        self.view.bringSubviewToFront(listButton)
        
    }
    
    @IBAction func menuButtonTapped(sender: UIButton) {
    
        self.slideMenuController()?.openLeft()
    
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













