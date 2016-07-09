//
//  CustomDayView.swift
//  iXplore
//
//  Created by Alexander Ge on 7/7/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import Foundation
import UIKit

class CustomDayView : UIScrollView {
    
    // the date being shown
    var date: NSDate!
    var eventViews: [CustomEventView] = []
    var allDayEvents: [(String, [String])] = []
    var indentAmount: CGFloat = 5
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    
    // passed in. needed to set scroll view content size
    var titleHeight: CGFloat!
    var titleWidth: CGFloat!
    var blockHeight: CGFloat!
    var titleLeadingWhiteSpace: CGFloat!
    var lineLeadingWhiteSpace: CGFloat!
    var lineTrailingWhiteSpace: CGFloat!
    
    // layout things that dont affect content size
    var eventInitialIndent: CGFloat!
    let eventLeadingWhiteSpace: CGFloat = 5
    
    func loadView() {
        
        eventInitialIndent = titleLeadingWhiteSpace + lineLeadingWhiteSpace + titleWidth + eventLeadingWhiteSpace
        
        var titleY = titleHeight! / 2
        var lineY = titleHeight!
        
        for i in 0...24 {
            let line = UIView(frame: CGRectMake(lineLeadingWhiteSpace + titleLeadingWhiteSpace + titleWidth, lineY, self.frame.width - titleLeadingWhiteSpace - titleWidth - lineLeadingWhiteSpace - lineTrailingWhiteSpace, 1))
            line.backgroundColor = UIColor.lightGrayColor()
            
            let title = UILabel(frame: CGRectMake(titleLeadingWhiteSpace, titleY, titleWidth, titleHeight))
            title.font = UIFont(name: "Lato-Thin", size: 12)
            title.textAlignment = .Right
//            title.textColor = UIColor.lightTextColor()
            title.text = String(i) + ":00"
            
            self.addSubview(line)
            self.addSubview(title)
            
            titleY += blockHeight
            lineY += blockHeight
        }
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        let dateComponents = calendar?.components([.Month, .Day, .Year, .Hour, .Minute, .Weekday], fromDate: date)
        
        UIView.animateWithDuration(0.8, animations: {
            self.contentOffset = CGPointMake(0, 9 * self.blockHeight)
        })
        
//        self.loadEvents()
        
    }
    
//    func loadEvents() {
//
////        let event1 = Event(startDateString: "2016-07-08T09:30:00+00:00", endDateString: "2016-07-08T10:30:00+00:00")
////        let event2 = Event(startDateString: "2016-07-08T09:50:00+00:00", endDateString: "2016-07-08T10:50:00+00:00")
////        let event3 = Event(startDateString: "2016-07-08T10:05:00+00:00", endDateString: "2016-07-08T10:55:00+00:00")
////        self.eventListComplete([event1, event2, event3])
//        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.locale = NSLocale(localeIdentifier: "UTC")
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let dateString = dateFormatter.stringFromDate(self.date)
//        
//        let webService = WebService()
//        
//        let request = webService.createMutableAnonRequest(NSURL(string: "https://api.teamup.com/ks1b61e773b115d98d/events?tz=UTC&startDate=\(dateString)&endDate=\(dateString)"), method: "GET", parameters: nil, headers: ["Teamup-Token": "cda8c60dd507aa16f22f19e900799b732356ef63d825c0bee56fd98abee67f97"])
//        
//        webService.executeRequest(request, presentingViewController: nil, requestCompletionFunction: {(responseCode, json) in
//            
//            if responseCode / 100 == 2 {
//                
//                var events: [Event] = []
//                
//                for (_,event) in json["events"] {
//                    print(event["title"].stringValue)
//                    events.append(Event(title: event["title"].stringValue, startDateString: event["start_dt"].stringValue, endDateString: event["end_dt"].stringValue))
//                }
//                
//                self.eventListComplete(events)
//            }
//            else {
//                print("Didn't Work")
//            }
//            
//        })
//        
//    }
    
//    func eventListComplete(loadedEvents: [Event]) {
//        for newEvent in loadedEvents {
//            let newEventView = CustomEventView()
//            newEventView.event = newEvent
//            newEventView.indent = indentAmount
//            for eventView in eventViews {
//                if eventView.event.endDate.compare(newEvent.startDate) == .OrderedDescending {
//                    if withinHalfHour(eventView.event.startDate, compareDate: newEvent.startDate) {
//                        if eventView.positionInConflicts == newEventView.positionInConflicts {
//                            eventView.numberOfConflicts += 1
//                            newEventView.positionInConflicts += 1
//                        }
//                        newEventView.numberOfConflicts = eventView.numberOfConflicts
//                        newEventView.indent = eventView.indent
//                    }
//                    else {
//                        newEventView.indent = eventView.indent + indentAmount
//                    }
//                }
//            }
//            eventViews.append(newEventView)
//        }
//        print(eventViews)
//        self.displayEvents()
//    }
    
    func displayEvents() {
        for eventView in eventViews {
            let width: CGFloat = getWidthOfEventView(eventView)
            eventView.frame = CGRectMake(getXCorOfEventView(eventView, width: width), CGFloat(getStartOfEvent(eventView.event)) * (blockHeight / CGFloat(60)) + titleHeight, width, CGFloat(durationOfEvent(eventView.event)) * (blockHeight / CGFloat(60)))
            eventView.loadView()
            self.addSubview(eventView)
            self.bringSubviewToFront(eventView)
        }
        
    }
    
//    func withinHalfHour(fromDate: NSDate, compareDate: NSDate) -> Bool {
//        let halfHourComponent = NSDateComponents()
//        halfHourComponent.minute = 30
//        let halfHourDate = calendar?.dateByAddingComponents(halfHourComponent, toDate: fromDate, options: .MatchStrictly)
//        if halfHourDate?.compare(compareDate) == .OrderedDescending {
//            return true
//        }
//        return false
//    }
    
    func getXCorOfEventView(eventView: CustomEventView, width: CGFloat) -> CGFloat {
        var leadingSpace: CGFloat = titleLeadingWhiteSpace + titleWidth + lineLeadingWhiteSpace + eventView.indent
        if eventView.numberOfConflicts != 0 {
            leadingSpace += CGFloat(eventView.positionInConflicts) * width
        }
        return leadingSpace
    }
    
    func durationOfEvent(event: Event) -> Int {
        let startDateComponents = calendar?.components([.Hour, .Minute], fromDate: event.startDate)
        let endDateComponents = calendar?.components([.Hour, .Minute], fromDate: event.endDate)
        return (((endDateComponents?.hour)! - (startDateComponents?.hour)!) * 60) + ((endDateComponents?.minute)! - (startDateComponents?.minute)!)
    }
    
    func getStartOfEvent(event: Event) -> Int {
        let dateComponents = calendar?.components([.Hour, .Minute], fromDate: event.startDate)
        return ((dateComponents?.hour)! * 60) + (dateComponents?.minute)!
    }
    
    func getWidthOfEventView(eventView: CustomEventView) -> CGFloat {
        if eventView.numberOfConflicts != 0 {
            return (self.frame.width - (titleLeadingWhiteSpace + titleWidth + lineLeadingWhiteSpace + eventView.indent + lineTrailingWhiteSpace)) / CGFloat(eventView.numberOfConflicts + 1)
        }
        else {
            return self.frame.width - (titleLeadingWhiteSpace + titleWidth + lineLeadingWhiteSpace + eventView.indent + lineTrailingWhiteSpace)
        }
    }
    
}
