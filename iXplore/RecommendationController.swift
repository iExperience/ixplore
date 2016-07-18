//
//  RecommendationController.swift
//  iXplore
//
//  Created by Brian Ge on 7/15/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import Foundation
import UIKit

struct Recommendation {
    var coordinates: CLLocationCoordinate2D
    var name: String
    var info: String
    var rating: Int
    var price: Int
    var mustTry: String?
}