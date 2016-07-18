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

class RecommendationsMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    // IBOutlets for button layout
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var listButton: UIButton!
    
    // to get user location
    let locationManager = CLLocationManager()
    
    var mapView = GMSMapView()
    
    var restaurants: [Recommendation]!
    var cafes: [Recommendation]!
    var bars: [Recommendation]!
    var clubs: [Recommendation]!
    var hotspots: [Recommendation]!
    var sights: [Recommendation]!
    var markets: [Recommendation]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request user location.
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        // Set up Google map frame
        let window = UIApplication.sharedApplication().keyWindow
        self.mapView.frame = CGRectMake(0, 0, window!.frame.width, window!.frame.height)
        self.mapView.delegate = self
        
        // Set camera over w17
        let w17 = CLLocationCoordinate2D(latitude: -33.907181, longitude: 18.418592)
        self.mapView.camera = GMSCameraPosition(target: w17, zoom: 3, bearing: 0, viewingAngle: 0)
        
        self.mapView.myLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.compassButton = true

        mapView.delegate = self
        
        print(mapView.myLocation?.coordinate)
        
        // Test marker
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
        
        // Views setup
        listButton.layer.cornerRadius = 5
        
        self.view.addSubview(mapView)
        self.view.sendSubviewToBack(mapView)
        self.alamo()
//        self.populateRecommendations()
        
    }
    
//    func mapViewDidFinishTileRendering(mapView: GMSMapView) {
//        print("yes")
//        self.alamo()
//    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(true)
//        print("yes")
//        self.alamo()
//    }
    
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
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let customMarker = marker as? CustomGMSMarker
        let infoView = CustomInfoView(title: customMarker!.name, rating: customMarker!.rating, price: customMarker!.price, width: 125)
        return infoView
        
    }
    
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        
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
    
    func alamo() {
        
        let webService = WebService()
        
        let restaurantRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=fUPOKKFhqcQ&lid=fUPOKKFhqcQ&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(restaurantRequest, presentingViewController: self, requestCompletionFunction: {(responseCode, data) in
            print(responseCode)
            self.restaurants = self.loadRecommendations(data)
            for restaurant in self.restaurants {
                let marker = GMSMarker()
                marker.position = restaurant.coordinates
                marker.title = restaurant.title
                marker.snippet = restaurant.description
                marker.map = self.mapView
            }

        })
        
        let cafeRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=6FGPhFJrpjM&lid=6FGPhFJrpjM&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(cafeRequest, presentingViewController: self, requestCompletionFunction: {(responseCode, data) in
            print(responseCode)
            self.cafes = self.loadRecommendations(data)
            for cafe in self.cafes {
                let marker = GMSMarker()
                marker.position = cafe.coordinates
                marker.title = cafe.title
                marker.snippet = cafe.description
                marker.map = self.mapView
            }

        })
        
        let barRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=ZEelh6BGeVc&lid=ZEelh6BGeVc&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(barRequest, presentingViewController: self, requestCompletionFunction: {(responseCode, data) in
            print(responseCode)
            self.bars = self.loadRecommendations(data)
            for bar in self.bars {
                let marker = GMSMarker()
                marker.position = bar.coordinates
                marker.title = bar.title
                marker.snippet = bar.description
                marker.map = self.mapView
            }

        })
        
        let clubRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=2AejuegPDEA&lid=2AejuegPDEA&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(clubRequest, presentingViewController: self, requestCompletionFunction: {(responseCode, data) in
            print(responseCode)
            self.clubs = self.loadRecommendations(data)
            for club in self.clubs {
                let marker = GMSMarker()
                marker.position = club.coordinates
                marker.title = club.title
                marker.snippet = club.description
                marker.map = self.mapView
            }

        })
        
        let hotspotRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=Q1M-z31Kq7c&lid=Q1M-z31Kq7c&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(hotspotRequest, presentingViewController: self, requestCompletionFunction: {(responseCode, data) in
            print(responseCode)
            self.hotspots = self.loadRecommendations(data)
            for hotspot in self.hotspots {
                let marker = GMSMarker()
                marker.position = hotspot.coordinates
                marker.title = hotspot.title
                marker.snippet = hotspot.description
                marker.map = self.mapView
            }
            
        })
        
        let sightRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=Hi_kojJKCDU&lid=Hi_kojJKCDU&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(sightRequest, presentingViewController: self, requestCompletionFunction: {(responseCode, data) in
            print(responseCode)
            self.sights = self.loadRecommendations(data)
            for sight in self.sights {
                let marker = GMSMarker()
                marker.position = sight.coordinates
                marker.title = sight.title
                marker.snippet = sight.description
                marker.map = self.mapView
            }
            
        })
        
        let marketRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=OTmhq2fpBho&lid=OTmhq2fpBho&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(marketRequest, presentingViewController: self, requestCompletionFunction: {(responseCode, data) in
            print(responseCode)
            self.markets = self.loadRecommendations(data)
            for market in self.markets {
                let marker = GMSMarker()
                marker.position = market.coordinates
                marker.title = market.title
                marker.snippet = market.description
                marker.map = self.mapView
            }
            
        })
        
    }
    
    func loadRecommendations(data: NSData) -> [Recommendation] {
        
        var recommendations: [Recommendation] = []
        
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
            let description = string.substringWithRange(index!..<endIndex!)
            index = string.characters.indexOf(">")?.advancedBy(1)
            
            string = string.substringFromIndex(index!)
            var mustTry: String?
            index = string.characters.indexOf(":")?.advancedBy(1)
            if index != string.endIndex {
                mustTry = string.substringFromIndex(index!.advancedBy(1))
            }
            
            recommendations.append(Recommendation(coordinates: (point as! MKAnnotation).coordinate, title: (point as! MKAnnotation).title!!, description: description, rating: rating!, price: price!, must: mustTry))
        }
        
        return recommendations
    }

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
}
