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
    
    // IBOutlets for button layout
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var listButton: UIButton!
    
    // to get user location
    let locationManager = CLLocationManager()
    
    var mapView = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request user location.
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        // Set up Google map frame
        let window = UIApplication.sharedApplication().keyWindow
        self.mapView.frame = CGRectMake(0, 0, window!.frame.width, window!.frame.height)
        
        // Set camera over w17
        let w17 = CLLocationCoordinate2D(latitude: -33.907181, longitude: 18.418592)
        self.mapView.camera = GMSCameraPosition(target: w17, zoom: 3, bearing: 0, viewingAngle: 0)
        
        self.mapView.myLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        
        // Test marker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        // Views setup
        listButton.layer.cornerRadius = 5
        
        self.view.addSubview(mapView)
        self.view.sendSubviewToBack(mapView)
    }
    
    // MARK: IBActions
    
    @IBAction func menuButtonTapped(sender: UIButton) {

        self.slideMenuController()?.openLeft()
    }
    
    // MARK: Location delegate methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
}
