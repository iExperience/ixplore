//
//  UserController.swift
//  iXplore
//
//  Created by Brian Ge on 7/5/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import Foundation
import UIKit

struct User {
    var id: String
    var image: UIImageView
    var firstName: String
    var lastName: String
}

class UserController {
    
    var user: User?
    
    // Creates a shared instance
    class var sharedInstance: UserController {
        struct Static {
            static var instance:UserController?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token)    {
            Static.instance = UserController()
        }
        return Static.instance!
    }
    
}
