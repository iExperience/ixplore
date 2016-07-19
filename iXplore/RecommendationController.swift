//
//  RecommendationController.swift
//  iXplore
//
//  Created by Brian Ge on 7/15/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import CoreLocation
import SSZipArchive
import Alamofire

struct Recommendation {
    
    var coordinates: CLLocationCoordinate2D
    var name: String
    var info: String
    var rating: Int
    var price: Int
    var mustTry: String?
    
}

class RecommendationController {
    
    var restaurants: [CustomGMSMarker]!
    var cafes: [CustomGMSMarker]!
    var bars: [CustomGMSMarker]!
    var clubs: [CustomGMSMarker]!
    var hotspots: [CustomGMSMarker]!
    var sights: [CustomGMSMarker]!
    var markets: [CustomGMSMarker]!
    
    // Creates a shared instance
    class var sharedInstance: RecommendationController {
        
        struct Static {
            static var instance: RecommendationController?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token)    {
            Static.instance = RecommendationController()
        }
        return Static.instance!
    }
    
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
    
    func getRecommendations(mapCompletion firstCompletion: ([CustomGMSMarker]) -> Void, listCompletion secondCompletion: ([CustomGMSMarker]) -> Void) {
        
        let webService = WebService()
        
        let restaurantRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=fUPOKKFhqcQ&lid=fUPOKKFhqcQ&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(restaurantRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
            
            print(responseCode)
            self.restaurants = self.loadRecommendations(data)
            firstCompletion(self.restaurants)
            secondCompletion(self.restaurants)
            
        })
        
        let cafeRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=6FGPhFJrpjM&lid=6FGPhFJrpjM&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(cafeRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
            
            print(responseCode)
            self.cafes = self.loadRecommendations(data)
            firstCompletion(self.cafes)
            secondCompletion(self.cafes)
            
        })
        
        let barRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=ZEelh6BGeVc&lid=ZEelh6BGeVc&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(barRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
            
            print(responseCode)
            self.bars = self.loadRecommendations(data)
            firstCompletion(self.bars)
            secondCompletion(self.bars)
            
        })
        
        let clubRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=2AejuegPDEA&lid=2AejuegPDEA&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(clubRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
            
            print(responseCode)
            self.clubs = self.loadRecommendations(data)
            firstCompletion(self.clubs)
            secondCompletion(self.clubs)
            
        })
        
        let hotspotRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=Q1M-z31Kq7c&lid=Q1M-z31Kq7c&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(hotspotRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
            
            print(responseCode)
            self.hotspots = self.loadRecommendations(data)
            firstCompletion(self.hotspots)
            secondCompletion(self.hotspots)
            
        })
        
        let sightRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=Hi_kojJKCDU&lid=Hi_kojJKCDU&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(sightRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
            
            print(responseCode)
            self.sights = self.loadRecommendations(data)
            firstCompletion(self.sights)
            secondCompletion(self.sights)
            
        })
        
        let marketRequest = webService.createMutableRequest(NSURL(string: "https://www.google.com/maps/d/u/0/kml?mid=1aazZw6MA1FnVIZvT4PkRNd-WDZw&amp%3Blid=OTmhq2fpBho&lid=OTmhq2fpBho&forcekml=1&cid=mp&cv=LLS4f3GpivQ.en."), method: "GET", parameters: nil, headers: nil)
        
        webService.executeDataRequest(marketRequest, presentingViewController: nil, requestCompletionFunction: {(responseCode, data) in
            
            print(responseCode)
            self.markets = self.loadRecommendations(data)
            firstCompletion(self.markets)
            secondCompletion(self.markets)
            
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
            //            marker.map = self.mapView
            recommendations.append(marker)

        }
        
        return recommendations
    }
    
}
        }
        
        return recommendations
        
    }
    
}
