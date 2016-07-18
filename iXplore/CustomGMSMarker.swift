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
    
    var name: String!
    var rating: Int!
    var price: Int!
    var info: String!
    var mustTry: String?
    
    init(name: String, rating: Int, price: Int, info: String, mustTry: String?) {
        
        super.init()
        self.name = name
        self.rating = rating
        self.price = price
        self.info = info
        self.mustTry = mustTry
        
    }
    
    
}

















