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
import SSZipArchive
import Alamofire

class RecommendationsMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UIScrollViewDelegate, UINavigationControllerDelegate {
    
    var flipPresentAnimationController = FlipPresentAnimationController()
    var flipDismissAnimationController = FlipDismissAnimationController()
    
    // IBOutlets for button layout
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var filterScrollView: UIScrollView!
    
    var scrollViewHeight: CGFloat!
    
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
        self.scrollViewHeight = window!.frame.width / 7
        self.mapView.frame = CGRectMake(0, 0, window!.frame.width, window!.frame.height - self.scrollViewHeight)
        self.mapView.delegate = self
        
        // Set camera over w17
        let w17 = CLLocationCoordinate2D(latitude: -33.907181, longitude: 18.418592)
        self.mapView.camera = GMSCameraPosition(target: w17, zoom: 3, bearing: 0, viewingAngle: 0)
        
        self.mapView.myLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.compassButton = true

        mapView.delegate = self
        
        print(mapView.myLocation?.coordinate)
        
        // Views setup
        listButton.layer.cornerRadius = 5
        
        self.view.addSubview(mapView)
        self.view.sendSubviewToBack(mapView)
//        self.populateRecommendations()
        self.setupScrollView()
        
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return flipPresentAnimationController
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return flipDismissAnimationController
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.Push {
            if fromVC == self {
                return flipPresentAnimationController
            }
            else {
                return flipDismissAnimationController
            }
        }
        return nil
    }
    
    // MARK: IBActions
    
    @IBAction func menuButtonTapped(sender: UIButton) {

        self.slideMenuController()?.openLeft()
    }
    
    @IBAction func listButtonTapped(sender: UIButton) {
    
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.recommendationsNavigationController?.setViewControllers([appDelegate.rlvc], animated: true)
//        appDelegate.recommendationsNavigationController?.pushViewController(appDelegate.rlvc, animated: true)
    
    }
    
    
    func setupScrollView() {
        let restaurantButton = UIButton(frame: CGRectMake(0, 0, scrollViewHeight, scrollViewHeight))
        restaurantButton.setImage(UIImage(named: "restaurant.png"), forState: .Normal)
        restaurantButton.backgroundColor = UIColor.lightTextColor()
        restaurantButton.addTarget(self, action: #selector(self.toggleRestaurants(_:)), forControlEvents: .TouchUpInside)
        filterScrollView.addSubview(restaurantButton)
        
        let cafeButton = UIButton(frame: CGRectMake(scrollViewHeight, 0, scrollViewHeight, scrollViewHeight))
        cafeButton.setImage(UIImage(named: "cafe.png"), forState: .Normal)
        cafeButton.backgroundColor = UIColor.lightTextColor()
        cafeButton.addTarget(self, action: #selector(self.toggleCafes(_:)), forControlEvents: .TouchUpInside)
        filterScrollView.addSubview(cafeButton)
        
        let barButton = UIButton(frame: CGRectMake(2 * scrollViewHeight, 0, scrollViewHeight, scrollViewHeight))
        barButton.setImage(UIImage(named: "bar.png"), forState: .Normal)
        barButton.backgroundColor = UIColor.lightTextColor()
        barButton.addTarget(self, action: #selector(self.toggleBars(_:)), forControlEvents: .TouchUpInside)
        filterScrollView.addSubview(barButton)
        
        let clubButton = UIButton(frame: CGRectMake(3 * scrollViewHeight, 0, scrollViewHeight, scrollViewHeight))
        clubButton.setImage(UIImage(named: "club.png"), forState: .Normal)
        clubButton.backgroundColor = UIColor.lightTextColor()
        clubButton.addTarget(self, action: #selector(self.toggleClubs(_:)), forControlEvents: .TouchUpInside)
        filterScrollView.addSubview(clubButton)
        
        let hotspotButton = UIButton(frame: CGRectMake(4 * scrollViewHeight, 0, scrollViewHeight, scrollViewHeight))
        hotspotButton.setImage(UIImage(named: "hotspot.png"), forState: .Normal)
        hotspotButton.backgroundColor = UIColor.lightTextColor()
        hotspotButton.addTarget(self, action: #selector(self.toggleHotspots(_:)), forControlEvents: .TouchUpInside)
        filterScrollView.addSubview(hotspotButton)
        
        let sightButton = UIButton(frame: CGRectMake(5 * scrollViewHeight, 0, scrollViewHeight, scrollViewHeight))
        sightButton.setImage(UIImage(named: "sight.png"), forState: .Normal)
        sightButton.backgroundColor = UIColor.lightTextColor()
        sightButton.addTarget(self, action: #selector(self.toggleSights(_:)), forControlEvents: .TouchUpInside)
        filterScrollView.addSubview(sightButton)
        
        let marketButton = UIButton(frame: CGRectMake(6 * scrollViewHeight, 0, scrollViewHeight, scrollViewHeight))
        marketButton.setImage(UIImage(named: "market.png"), forState: .Normal)
        marketButton.backgroundColor = UIColor.lightTextColor()
        marketButton.addTarget(self, action: #selector(self.toggleMarkets(_:)), forControlEvents: .TouchUpInside)
        filterScrollView.addSubview(marketButton)
        
        filterScrollView.contentSize.width = 7 * scrollViewHeight
        filterScrollView.userInteractionEnabled = true
        filterScrollView.scrollEnabled = true
    }
    
    func shouldShowAll() -> Bool {
        for subview in filterScrollView.subviews {
            if let subview = subview as? UIButton {
                if subview.selected {
                    return false
                }
            }
        }
        return true
    }
    
    func buttonTapped(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected {
            sender.backgroundColor = UIColor(netHex: 0xe32181).colorWithAlphaComponent(0.5)
        }
        else {
            sender.backgroundColor = UIColor.lightTextColor()
        }
    }
    
    func toggleRestaurants(sender: UIButton) {
        
        if self.shouldShowAll() {
            mapView.clear()
        }
        
        self.buttonTapped(sender)
        
        if self.shouldShowAll() {
            for markers in [RecommendationController.sharedInstance.restaurants, RecommendationController.sharedInstance.cafes, RecommendationController.sharedInstance.bars, RecommendationController.sharedInstance.clubs, RecommendationController.sharedInstance.hotspots, RecommendationController.sharedInstance.sights, RecommendationController.sharedInstance.markets] {
                for marker in markers {
                    print("hey")
                    marker.map = mapView
                }
            }
        }
        else if sender.selected {
            for restaurant in RecommendationController.sharedInstance.restaurants {
                print(restaurant.name)
                restaurant.map = mapView
            }
        }
        else {
            for restaurant in RecommendationController.sharedInstance.restaurants {
                restaurant.map = nil
            }
        }
    }
    
    func toggleCafes(sender: UIButton) {
        
        if self.shouldShowAll() {
            mapView.clear()
        }
        
        self.buttonTapped(sender)
        
        if self.shouldShowAll() {
            for markers in [RecommendationController.sharedInstance.restaurants, RecommendationController.sharedInstance.cafes, RecommendationController.sharedInstance.bars, RecommendationController.sharedInstance.clubs, RecommendationController.sharedInstance.hotspots, RecommendationController.sharedInstance.sights, RecommendationController.sharedInstance.markets] {
                for marker in markers {
                    marker.map = mapView
                }
            }
        }
        else if sender.selected {
            for cafe in RecommendationController.sharedInstance.cafes {
                cafe.map = mapView
            }
        }
        else {
            for cafe in RecommendationController.sharedInstance.cafes {
                cafe.map = nil
            }
        }
    }
    
    func toggleBars(sender: UIButton) {
        
        if self.shouldShowAll() {
            mapView.clear()
        }
        
        self.buttonTapped(sender)
        
        if self.shouldShowAll() {
            for markers in [RecommendationController.sharedInstance.restaurants, RecommendationController.sharedInstance.cafes, RecommendationController.sharedInstance.bars, RecommendationController.sharedInstance.clubs, RecommendationController.sharedInstance.hotspots, RecommendationController.sharedInstance.sights, RecommendationController.sharedInstance.markets] {
                for marker in markers {
                    marker.map = mapView
                }
            }
        }
        else if sender.selected {
            for bar in RecommendationController.sharedInstance.bars {
                bar.map = mapView
            }
        }
        else {
            for bar in RecommendationController.sharedInstance.bars {
                bar.map = nil
            }
        }
    }
    
    func toggleClubs(sender: UIButton) {
        
        if self.shouldShowAll() {
            mapView.clear()
        }
        
        self.buttonTapped(sender)
        
        if self.shouldShowAll() {
            for markers in [RecommendationController.sharedInstance.restaurants, RecommendationController.sharedInstance.cafes, RecommendationController.sharedInstance.bars, RecommendationController.sharedInstance.clubs, RecommendationController.sharedInstance.hotspots, RecommendationController.sharedInstance.sights, RecommendationController.sharedInstance.markets] {
                for marker in markers {
                    marker.map = mapView
                }
            }
        }
        else if sender.selected {
            for club in RecommendationController.sharedInstance.clubs {
                club.map = mapView
            }
        }
        else {
            for club in RecommendationController.sharedInstance.clubs {
                club.map = nil
            }
        }
    }
    
    func toggleHotspots(sender: UIButton) {
        
        if self.shouldShowAll() {
            mapView.clear()
        }
        
        self.buttonTapped(sender)
        
        if self.shouldShowAll() {
            for markers in [RecommendationController.sharedInstance.restaurants, RecommendationController.sharedInstance.cafes, RecommendationController.sharedInstance.bars, RecommendationController.sharedInstance.clubs, RecommendationController.sharedInstance.hotspots, RecommendationController.sharedInstance.sights, RecommendationController.sharedInstance.markets] {
                for marker in markers {
                    marker.map = mapView
                }
            }
        }
        else if sender.selected {
            for hotspot in RecommendationController.sharedInstance.hotspots {
                hotspot.map = mapView
            }
        }
        else {
            for hotspot in RecommendationController.sharedInstance.hotspots {
                hotspot.map = nil
            }
        }
    }
    
    func toggleSights(sender: UIButton) {
        
        if self.shouldShowAll() {
            mapView.clear()
        }
        
        self.buttonTapped(sender)
        
        if self.shouldShowAll() {
            for markers in [RecommendationController.sharedInstance.restaurants, RecommendationController.sharedInstance.cafes, RecommendationController.sharedInstance.bars, RecommendationController.sharedInstance.clubs, RecommendationController.sharedInstance.hotspots, RecommendationController.sharedInstance.sights, RecommendationController.sharedInstance.markets] {
                for marker in markers {
                    marker.map = mapView
                }
            }
        }
        else if sender.selected {
            for sight in RecommendationController.sharedInstance.sights {
                sight.map = mapView
            }
        }
        else {
            for sight in RecommendationController.sharedInstance.sights {
                sight.map = nil
            }
        }
    }
    
    func toggleMarkets(sender: UIButton) {
        
        if self.shouldShowAll() {
            mapView.clear()
        }
        
        self.buttonTapped(sender)
        
        if self.shouldShowAll() {
            for markers in [RecommendationController.sharedInstance.restaurants, RecommendationController.sharedInstance.cafes, RecommendationController.sharedInstance.bars, RecommendationController.sharedInstance.clubs, RecommendationController.sharedInstance.hotspots, RecommendationController.sharedInstance.sights, RecommendationController.sharedInstance.markets] {
                for marker in markers {
                    marker.map = mapView
                }
            }
        }
        else if sender.selected {
            for market in RecommendationController.sharedInstance.markets {
                market.map = mapView
            }
        }
        else {
            for market in RecommendationController.sharedInstance.markets {
                market.map = nil
            }
        }
    }
    
    // MARK: Location delegate methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let customMarker = marker as? CustomGMSMarker
        let infoView = CustomInfoView(title: customMarker!.name, rating: customMarker!.rating, price: customMarker!.price, width: 125)
        return infoView
        
    }
    
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        let customMarker = marker as? CustomGMSMarker
        let rvc = RecommendationViewController(nibName: "RecommendationViewController", bundle: nil)
        rvc.recommendation = customMarker
        self.navigationController?.pushViewController(rvc, animated: true)
    }
    
    func populateRecommendations(recommendations: [CustomGMSMarker]) {
    
        for recommendation in recommendations {
            recommendation.map = self.mapView
        }
    
    }
    
}














