//
//  EventController.swift
//  iXplore
//
//  Created by Alexander Ge on 7/7/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import Foundation
import UIKit

class Event {
    
    var title: String!
    var who: String!
    var location: String!
    var subCalendarIds: [String]!
    
//    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    var startDate: NSDate!
    var endDate: NSDate!
    var description: NSAttributedString!
    
    init(title: String, description: String, who: String, location: String, startDateString: String, endDateString: String, subIds: [String]) {
        
        self.title = title
        self.who = who
        self.location = location
        self.subCalendarIds = subIds
        
        // formats the date
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        self.startDate = dateFormatter.dateFromString(startDateString)
        self.endDate = dateFormatter.dateFromString(endDateString)
        
        // description comes as string with HTML attributes 
        // parses for HTML attributes and formats accordingly
        self.description = try? NSAttributedString(data: NSString(string: description).dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding], documentAttributes: nil)
        
    }
    
}
