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

class RecommendationsMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UIScrollViewDelegate {
    
    // to get user location
    let locationManager = CLLocationManager()
    
    var mapView = GMSMapView()
    
//    var restaurants: [Recommendation]!
//    var cafes: [Recommendation]!
//    var bars: [Recommendation]!
//    var clubs: [Recommendation]!
//    var hotspots: [Recommendation]!
//    var sights: [Recommendation]!
//    var markets: [Recommendation]!
    
    // IBOutlets for button layout
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var filterScrollView: UIScrollView!
    
    var scrollViewHeight: CGFloat!
    
    @IBAction func listButtonTapped(sender: UIButton) {
    
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.recommendationsNavigationController?.setViewControllers([appDelegate.rlvc], animated: true)
    
    }
    var restaurants: [CustomGMSMarker] = []
    var cafes: [CustomGMSMarker] = []
    var bars: [CustomGMSMarker] = []
    var clubs: [CustomGMSMarker] = []
    var hotspots: [CustomGMSMarker] = []
    var sights: [CustomGMSMarker] = []
    var markets: [CustomGMSMarker] = []
    
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
        
//        print(mapView.myLocation?.coordinate)
        
        // Views setup
        listButton.layer.cornerRadius = 5
        
        self.view.addSubview(mapView)
        self.view.sendSubviewToBack(mapView)
//        RecommendationController.sharedInstance.getRecommendations(self.populateRecommendations)
//        self.placeRecommendations()
//        self.populateRecommendations()
        self.populateRecommendations()
        self.setupScrollView()
        
    }
    
    // MARK: IBActions
    
    @IBAction func menuButtonTapped(sender: UIButton) {

        self.slideMenuController()?.openLeft()
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
            for markers in [restaurants, cafes, bars, clubs, hotspots, sights, markets] {
                for marker in markers {
                    marker.map = nil
                }
            }
        }
        
        self.buttonTapped(sender)
        
        if self.shouldShowAll() {
            for markers in [restaurants, cafes, bars, clubs, hotspots, sights, markets] {
                for marker in markers {
                    marker.map = mapView
                }
            }
        }
        else if sender.selected {
            for restaurant in restaurants {
                restaurant.map = mapView
            }
        }
        else {
            for restaurant in restaurants {
                restaurant.map = nil
            }
        }
    }
    
    func toggleCafes(sender: UIButton) {
        
        if self.shouldShowAll() {
            for markers in [restaurants, cafes, bars, clubs, hotspots, sights, markets] {
                for marker in markers {
                    marker.map = nil
                }
            }
        }
        
        self.buttonTapped(sender)
        
        if self.shouldShowAll() {
            for markers in [restaurants, cafes, bars, clubs, hotspots, sights, markets] {
                for marker in markers {
                    marker.map = mapView
                }
            }
        }
        else if sender.selected || self.shouldShowAll() {
            for cafe in cafes {
                cafe.map = mapView
            }
        }
        else {
            for cafe in cafes {
                cafe.map = nil
            }
        }
    }
    
    func toggleBars(sender: UIButton) {
        
        if self.shouldShowAll() {
            for markers in [restaurants, cafes, bars, clubs, hotspots, sights, markets] {
                for marker in markers {
                    marker.map = nil
                }
            }
        }
        
        self.buttonTapped(sender)
        
        if self.shouldShowAll() {
            for markers in [restaurants, cafes, bars, clubs, hotspots, sights, markets] {
                for marker in markers {
                    marker.map = mapView
                }
            }
        }
        else if sender.selected || self.shouldShowAll() {
            for bar in bars {
                bar.map = mapView
            }
        }
        else {
            for bar in bars {
                bar.map = nil
            }
        }
    }
    
    func toggleClubs(sender: UIButton) {
        
        if self.shouldShowAll() {
            for markers in [restaurants, cafes, bars, clubs, hotspots, sights, markets] {
                for marker in markers {
                    marker.map = nil
                }
            }
        }
        
        self.buttonTapped(sender)
        
        if self.shouldShowAll() {
            for markers in [restaurants, cafes, bars, clubs, hotspots, sights, markets] {
                for marker in markers {
                    marker.map = mapView
                }
            }
        }
        else if sender.selected || self.shouldShowAll() {
            for club in clubs {
                club.map = mapView
            }
        }
        else {
            for club in clubs {
                club.map = nil
            }
        }
    }
    
    func toggleHotspots(sender: UIButton) {
        
        if self.shouldShowAll() {
            for markers in [restaurants, cafes, bars, clubs, hotspots, sights, markets] {
                for marker in markers {
                    marker.map = nil
                }
            }
        }
        
        self.buttonTapped(sender)
        
        if self.shouldShowAll() {
            for markers in [restaurants, cafes, bars, clubs, hotspots, sights, markets] {
                for marker in markers {
                    marker.map = mapView
                }
            }
        }
        else if sender.selected || self.shouldShowAll() {
            for hotspot in hotspots {
                hotspot.map = mapView
            }
        }
        else {
            for hotspot in hotspots {
                hotspot.map = nil
            }
        }
    }
    
    func toggleSights(sender: UIButton) {
        
        if self.shouldShowAll() {
            for markers in [restaurants, cafes, bars, clubs, hotspots, sights, markets] {
                for marker in markers {
                    marker.map = nil
                }
            }
        }
        
        self.buttonTapped(sender)
        
        if self.shouldShowAll() {
            for markers in [restaurants, cafes, bars, clubs, hotspots, sights, markets] {
                for marker in markers {
                    marker.map = mapView
                }
            }
        }
        else if sender.selected || self.shouldShowAll() {
            for sight in sights {
                sight.map = mapView
            }
        }
        else {
            for sight in sights {
                sight.map = nil
            }
        }
    }
    
    func toggleMarkets(sender: UIButton) {
        
        if self.shouldShowAll() {
            for markers in [restaurants, cafes, bars, clubs, hotspots, sights, markets] {
                for marker in markers {
                    marker.map = nil
                }
            }
        }
        
        self.buttonTapped(sender)
        
        if self.shouldShowAll() {
            for markers in [restaurants, cafes, bars, clubs, hotspots, sights, markets] {
                for marker in markers {
                    marker.map = mapView
                }
            }
        }
        else if sender.selected || self.shouldShowAll() {
            for market in markets {
                market.map = mapView
            }
        }
        else {
            for market in markets {
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
    
//    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
//    func loadRecommendations(urlPath: String) -> [Recommendation] {
//        
//        var recommendations: [Recommendation] = []
//        
//        let sourceUrl = NSURL(string: urlPath)!//&dummy=\(dateString)")!
//        
//        //Get the file name and create a destination URL
//        let zipPath = tempZipPath()
//        let destinationURL = NSURL(fileURLWithPath: zipPath)
//        
//        
//        //Hold this file as an NSData and write it to the new location
//        if let fileData = NSData(contentsOfURL: sourceUrl) {
//            fileData.writeToURL(destinationURL, atomically: false)   // true
//            print(destinationURL.path!)
//            
////            let unzipPath = tempUnzipPath()
////            SSZipArchive.unzipFileAtPath(zipPath, toDestination:unzipPath!)
//            
////            do {
////                print(try NSFileManager.defaultManager().contentsOfDirectoryAtPath(unzipPath!))
////            }
////            catch {
////                print("failed")
////            }
//            
////            let url = NSURL(fileURLWithPath: unzipPath! + "/doc.kml")
//            let parser = KMLParser(URL: destinationURL)
////            parser.parseKML()
//            
//            for point in parser.points {
//                print((point as! MKAnnotation).coordinate)
//                print("Name: " + (point as! MKAnnotation).title!!)
//                
//                var string = (point as! MKAnnotation).subtitle!!
//                
//                var index = string.characters.indexOf(":")
//                index = index?.advancedBy(2)
//                let rating = Int(String(string.characters[index!]))
//                index = string.characters.indexOf(">")?.advancedBy(1)
//                
//                string = string.substringFromIndex(index!)
//                
//                index = string.characters.indexOf(":")?.advancedBy(2)
//                let price = Int(String(string.characters[index!]))
//                index = string.characters.indexOf(">")?.advancedBy(1)
//                
//                string = string.substringFromIndex(index!)
//                
//                index = string.characters.indexOf(":")?.advancedBy(2)
//                let endIndex = string.characters.indexOf("<")
//                let description = string.substringWithRange(index!..<endIndex!)
//                index = string.characters.indexOf(">")?.advancedBy(1)
//                
//                string = string.substringFromIndex(index!)
//                var mustTry: String?
//                index = string.characters.indexOf(":")?.advancedBy(1)
//                if index != string.endIndex {
//                    mustTry = string.substringFromIndex(index!.advancedBy(1))
//                }
//                
//                recommendations.append(Recommendation(coordinates: (point as! MKAnnotation).coordinate, title: (point as! MKAnnotation).title!!, description: description, rating: rating!, price: price!, must: mustTry))
//                
////                print("Rating: \(rating)")
////                print("Price: \(price)")
////                print("Description: \(description)")
////                if let mustTry = mustTry {
////                    print("Must try: \(mustTry)")
////                }
//            }
//            do {
//                try NSFileManager.defaultManager().removeItemAtPath(zipPath)
////                try NSFileManager.defaultManager().removeItemAtPath(unzipPath! + "/doc.kml")
////                try NSFileManager.defaultManager().removeItemAtPath(unzipPath!)
//            }
//            catch {
//                print("nope")
//            }
//        }
//        
//        return recommendations
//    }
    
//    func placeRecommendations() {
//
//        for restaurant in RecommendationController.sharedInstance.restaurants {
//            let marker = CustomGMSMarker(name: restaurant.name, rating: restaurant.rating, price: restaurant.price, info: restaurant.info, mustTry: restaurant.mustTry)
//            marker.position = restaurant.coordinates
//            marker.map = self.mapView
//        }
//        for cafe in RecommendationController.sharedInstance.cafes {
//            let marker = CustomGMSMarker(name: cafe.name, rating: cafe.rating, price: cafe.price, info: cafe.info, mustTry: cafe.mustTry)
//            marker.position = cafe.coordinates
//            marker.map = self.mapView
//        }
//        for bar in RecommendationController.sharedInstance.bars {
//            let marker = CustomGMSMarker(name: bar.name, rating: bar.rating, price: bar.price, info: bar.info, mustTry: bar.mustTry)
//            marker.position = bar.coordinates
//            marker.map = self.mapView
//        }
//        for club in RecommendationController.sharedInstance.clubs {
//            let marker = CustomGMSMarker(name: club.name, rating: club.rating, price: club.price, info: club.info, mustTry: club.mustTry)
//            marker.position = club.coordinates
//            marker.map = self.mapView
//        }
//        for hotspot in RecommendationController.sharedInstance.hotspots {
//            let marker = CustomGMSMarker(name: hotspot.name, rating: hotspot.rating, price: hotspot.price, info: hotspot.info, mustTry: hotspot.mustTry)
//            marker.position = hotspot.coordinates
//            marker.map = self.mapView
//        }
//        for sight in RecommendationController.sharedInstance.sights {
//            let marker = CustomGMSMarker(name: sight.name, rating: sight.rating, price: sight.price, info: sight.info, mustTry: sight.mustTry)
//            marker.position = sight.coordinates
//            marker.map = self.mapView
//        }
//        for market in RecommendationController.sharedInstance.markets {
//            let marker = CustomGMSMarker(name: market.name, rating: market.rating, price: market.price, info: market.info, mustTry: market.mustTry)
//            marker.position = market.coordinates
//            marker.map = self.mapView
//        }
//        
//    }
    
//    func tempZipPath() -> String {
//        var path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
//        path += "/\(NSUUID().UUIDString).kml"
//        return path
//    }
//    
//    func tempUnzipPath() -> String? {
//        var path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
//        path += "/\(NSUUID().UUIDString)"
//        let url = NSURL(fileURLWithPath: path)
//        
//        do {
//            try NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil)
//        } catch {
//            return nil
//        }
//        
//        if let path = url.path {
//            return path
//        }
//        
//        return nil
//    }
//    
//    func alamo() {
//        
//        let webService = WebService()
//        
//        let restaurantRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=fUPOKKFhqcQ&lid=fUPOKKFhqcQ&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
//        
//        webService.executeDataRequest(restaurantRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
//            print(responseCode)
//            self.restaurants = self.loadRecommendations(data)
//            for restaurant in self.restaurants {
//                let marker = CustomGMSMarker(name: restaurant.name, rating: restaurant.rating, price: restaurant.price, info: restaurant.info, mustTry: restaurant.mustTry)
//                marker.position = restaurant.coordinates
//                marker.map = self.mapView
//            }
//
//        })
//        
//        let cafeRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=6FGPhFJrpjM&lid=6FGPhFJrpjM&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
//        
//        webService.executeDataRequest(cafeRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
//            print(responseCode)
//            self.cafes = self.loadRecommendations(data)
//            for cafe in self.cafes {
//                let marker = CustomGMSMarker(name: cafe.name, rating: cafe.rating, price: cafe.price, info: cafe.info, mustTry: cafe.mustTry)
//                marker.position = cafe.coordinates
//                marker.map = self.mapView
//            }
//
//        })
//        
//        let barRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=ZEelh6BGeVc&lid=ZEelh6BGeVc&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
//        
//        webService.executeDataRequest(barRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
//            print(responseCode)
//            self.bars = self.loadRecommendations(data)
//            for bar in self.bars {
//                let marker = CustomGMSMarker(name: bar.name, rating: bar.rating, price: bar.price, info: bar.info, mustTry: bar.mustTry)
//                marker.position = bar.coordinates
//                marker.map = self.mapView
//            }
//
//        })
//        
//        let clubRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=2AejuegPDEA&lid=2AejuegPDEA&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
//        
//        webService.executeDataRequest(clubRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
//            print(responseCode)
//            self.clubs = self.loadRecommendations(data)
//            for club in self.clubs {
//                let marker = CustomGMSMarker(name: club.name, rating: club.rating, price: club.price, info: club.info, mustTry: club.mustTry)
//                marker.position = club.coordinates
//                marker.map = self.mapView
//            }
//
//        })
//        
//        let hotspotRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=Q1M-z31Kq7c&lid=Q1M-z31Kq7c&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
//        
//        webService.executeDataRequest(hotspotRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
//            print(responseCode)
//            self.hotspots = self.loadRecommendations(data)
//            for hotspot in self.hotspots {
//                let marker = CustomGMSMarker(name: hotspot.name, rating: hotspot.rating, price: hotspot.price, info: hotspot.info, mustTry: hotspot.mustTry)
//                marker.position = hotspot.coordinates
//                marker.map = self.mapView
//            }
//            
//        })
//        
//        let sightRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=Hi_kojJKCDU&lid=Hi_kojJKCDU&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
//        
//        webService.executeDataRequest(sightRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
//            print(responseCode)
//            self.sights = self.loadRecommendations(data)
//            for sight in self.sights {
//                let marker = CustomGMSMarker(name: sight.name, rating: sight.rating, price: sight.price, info: sight.info, mustTry: sight.mustTry)
//                marker.position = sight.coordinates
//                marker.map = self.mapView
//            }
//            
//        })
//        
//        let marketRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=OTmhq2fpBho&lid=OTmhq2fpBho&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
//        
//        webService.executeDataRequest(marketRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
//            print(responseCode)
//            self.markets = self.loadRecommendations(data)
//            for market in self.markets {
//                let marker = CustomGMSMarker(name: market.name, rating: market.rating, price: market.price, info: market.info, mustTry: market.mustTry)
//                marker.position = market.coordinates
//                marker.map = self.mapView
//            }
//            
//        })
//        
//    }
//    
//    func loadRecommendations(data: NSData) -> [Recommendation] {
//        
//        var recommendations: [Recommendation] = []
//        
//        let parser = KMLParser(data: data)
//        parser.parseKML()
//        
//        for point in parser.points {
//            print((point as! MKAnnotation).coordinate)
//            print("Name: " + (point as! MKAnnotation).title!!)
//            
//            var string = (point as! MKAnnotation).subtitle!!
//            
//            var index = string.characters.indexOf(":")
//            index = index?.advancedBy(2)
//            let rating = Int(String(string.characters[index!]))
//            index = string.characters.indexOf(">")?.advancedBy(1)
//            
//            string = string.substringFromIndex(index!)
//            
//            index = string.characters.indexOf(":")?.advancedBy(2)
//            let price = Int(String(string.characters[index!]))
//            index = string.characters.indexOf(">")?.advancedBy(1)
//            
//            string = string.substringFromIndex(index!)
//            
//            index = string.characters.indexOf(":")?.advancedBy(2)
//            let endIndex = string.characters.indexOf("<")
//            let info = string.substringWithRange(index!..<endIndex!)
//            index = string.characters.indexOf(">")?.advancedBy(1)
//            
//            string = string.substringFromIndex(index!)
//            var mustTry: String?
//            index = string.characters.indexOf(":")?.advancedBy(1)
//            if index != string.endIndex {
//                mustTry = string.substringFromIndex(index!.advancedBy(1))
//            }
//            
//            recommendations.append(Recommendation(coordinates: (point as! MKAnnotation).coordinate, name: (point as! MKAnnotation).title!!, info: info, rating: rating!, price: price!, mustTry: mustTry))
//        }
//        
//        return recommendations
//    }

//    func populateRecommendations() {
//        restaurants = loadRecommendations("https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=fUPOKKFhqcQ&lid=fUPOKKFhqcQ&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en.")
//        cafes = loadRecommendations("https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=fUPOKKFhqcQ&lid=6FGPhFJrpjM&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en.")
//        bars = loadRecommendations("https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=fUPOKKFhqcQ&lid=ZEelh6BGeVc&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en.")
//        clubs = loadRecommendations("https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=fUPOKKFhqcQ&lid=2AejuegPDEA&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en.")
//        hotspots = loadRecommendations("https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=fUPOKKFhqcQ&lid=Q1M-z31Kq7c&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en.")
//        sights = loadRecommendations("https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=fUPOKKFhqcQ&lid=Hi_kojJKCDU&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en.")
//        markets = loadRecommendations("https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=fUPOKKFhqcQ&lid=OTmhq2fpBho&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en.")
//        
//        for restaurant in restaurants {
//            let marker = GMSMarker()
//            marker.position = restaurant.coordinates
//            marker.title = restaurant.title
//            marker.snippet = restaurant.description
//            marker.map = mapView
//        }
//        for cafe in cafes {
//            let marker = GMSMarker()
//            marker.position = cafe.coordinates
//            marker.title = cafe.title
//            marker.snippet = cafe.description
//            marker.map = mapView
//        }
//        for bar in bars {
//            let marker = GMSMarker()
//            marker.position = bar.coordinates
//            marker.title = bar.title
//            marker.snippet = bar.description
//            marker.map = mapView
//        }
//        for club in clubs {
//            let marker = GMSMarker()
//            marker.position = club.coordinates
//            marker.title = club.title
//            marker.snippet = club.description
//            marker.map = mapView
//        }
//        for hotspot in hotspots {
//            let marker = GMSMarker()
//            marker.position = hotspot.coordinates
//            marker.title = hotspot.title
//            marker.snippet = hotspot.description
//            marker.map = mapView
//        }
//        for sight in sights {
//            let marker = GMSMarker()
//            marker.position = sight.coordinates
//            marker.title = sight.title
//            marker.snippet = sight.description
//            marker.map = mapView
//        }
//        for market in markets {
//            let marker = GMSMarker()
//            marker.position = market.coordinates
//            marker.title = market.title
//            marker.snippet = market.description
//            marker.map = mapView
//        }
//    }
//    
    func tempZipPath() -> String {
        var path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
        path += "/\(NSUUID().UUIDString).kml"
        return path
    }
    
    func tempUnzipPath() -> String? {
        var path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
        path += "/\(NSUUID().UUIDString)"
        let url = NSURL(fileURLWithPath: path)
        
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return nil
        }
        
        if let path = url.path {
            return path
        }
        
        return nil
    }
    
    func populateRecommendations() {
        
        let webService = WebService()
        
        let restaurantRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=fUPOKKFhqcQ&lid=fUPOKKFhqcQ&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(restaurantRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
            
            print(responseCode)
            self.restaurants = self.loadRecommendations(data)
            
        })
        
        let cafeRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=6FGPhFJrpjM&lid=6FGPhFJrpjM&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(cafeRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
            
            print(responseCode)
            self.cafes = self.loadRecommendations(data)
            
        })
        
        let barRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=ZEelh6BGeVc&lid=ZEelh6BGeVc&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(barRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
            
            print(responseCode)
            self.bars = self.loadRecommendations(data)
            
        })
        
        let clubRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=2AejuegPDEA&lid=2AejuegPDEA&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(clubRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
            
            print(responseCode)
            self.clubs = self.loadRecommendations(data)
            
        })
        
        let hotspotRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=Q1M-z31Kq7c&lid=Q1M-z31Kq7c&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(hotspotRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
            
            print(responseCode)
            self.hotspots = self.loadRecommendations(data)
            
        })
        
        let sightRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=Hi_kojJKCDU&lid=Hi_kojJKCDU&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(sightRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
            
            print(responseCode)
            self.sights = self.loadRecommendations(data)
            
        })
        
        let marketRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=OTmhq2fpBho&lid=OTmhq2fpBho&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(marketRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
            
            print(responseCode)
            self.markets = self.loadRecommendations(data)
            
        })
        
    }
    
    func loadRecommendations(data: NSData) -> [CustomGMSMarker] {
        
        var recommendations: [CustomGMSMarker] = []
        
        let parser = KMLParser(data: data)
        parser.parseKML()
        
        for point in parser.points {
            print((point as! MKAnnotation).coordinate)
            print("Name: " + (point as! MKAnnotation).title!!)
            
            var string = (point as! MKAnnotation).subtitle!!
            
            var index = string.characters.indexOf(":")
            index = index?.advancedBy(2)
            let rating = Int(String(string.characters[index!]))
            index = string.characters.indexOf(">")?.advancedBy(1)
            
            string = string.substringFromIndex(index!)
            
            index = string.characters.indexOf(":")?.advancedBy(2)
            let price = Int(String(string.characters[index!]))
            index = string.characters.indexOf(">")?.advancedBy(1)
            
            string = string.substringFromIndex(index!)
            
            index = string.characters.indexOf(":")?.advancedBy(2)
            let endIndex = string.characters.indexOf("<")
            let info = string.substringWithRange(index!..<endIndex!)
            index = string.characters.indexOf(">")?.advancedBy(1)
            
            string = string.substringFromIndex(index!)
            var mustTry: String?
            index = string.characters.indexOf(":")?.advancedBy(1)
            if index != string.endIndex {
                mustTry = string.substringFromIndex(index!.advancedBy(1))
            }
            
            let marker = CustomGMSMarker(position: (point as! MKAnnotation).coordinate, name: (point as! MKAnnotation).title!!, rating: rating!, price: price!, info: info, mustTry: mustTry)
            marker.map = self.mapView
            recommendations.append(marker)
        }
        
        return recommendations
    }
    
    func populateRecommendations(recommendations: [CustomGMSMarker]) {
        for recommendation in recommendations {
            recommendation.map = mapView
        }
    }
    
}
