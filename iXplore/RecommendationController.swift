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
    var title: String
    var description: String
    var rating: Int
    var price: Int
    var must: String?
}