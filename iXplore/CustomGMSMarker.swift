//
//  CustomGMSMarker.swift
//  iXplore
//
//  Created by Alexander Ge on 7/18/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import Foundation
import GoogleMaps
import UIKit

class CustomGMSMarker: GMSMarker {
    
    var name: String
    var rating: Int
    var price: Int
    var info: String
    var mustTry: String?
    
    init(Rating: Int, Price: Int, Info: String, MustTry: String?) {
        
        super.init()
        self.rating = Rating
        self.price = Price
        self.info = Info
        self.mustTry = MustTry
        
    }
    
    
}

















