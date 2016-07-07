//
//  CustomWeekView.swift
//  iXplore
//
//  Created by Alexander Ge on 7/7/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import Foundation
import UIKit

class CustomWeekView : UIView {
    
    var delegate: CustomWeekViewDelegate?
    var startDate : NSDate!
    var dates : [(UIButton,NSDate)] = []
    var currentDate : NSDate!
    var buttonSize: CGFloat!
    var whiteSpace: CGFloat!
    
    func populateDates() {
        
        var xCor: CGFloat = 0
        var date = self.startDate
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        calendar?.timeZone = NSTimeZone.localTimeZone()
        let component = NSDateComponents()
        component.day = 1
        
        for i in 0...6 {
            let button = UIButton(frame: CGRectMake(xCor, 0, self.buttonSize!, self.buttonSize!))
            
            button.layer.cornerRadius = button.frame.width / 2
            
            button.tag = i
            button.addTarget(self, action: #selector(dateButtonTapped(_:)), forControlEvents: .TouchUpInside)
            
            let dateInt = calendar?.component(.Day, fromDate: date)
            
            button.setTitle(String(dateInt!), forState: .Normal)
            
            self.setButtonColor(button, date: date)
            
            self.addSubview(button)
            
            self.dates.append((button,date))
            
            date = calendar?.dateByAddingComponents(component, toDate: date, options: .MatchStrictly)
            
            xCor += self.whiteSpace! + self.buttonSize!
        }
        
    }
    
    func dateButtonTapped(sender: UIButton) {
        
        for (button, date) in dates {
            self.setButtonColor(button, date: date)
        }
        
        let (_,selectedDate) = dates[sender.tag]
        self.delegate?.dateSelected(selectedDate)
        if selectedDate == currentDate {
            sender.backgroundColor = UIColor.redColor()
            sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
        else {
            sender.backgroundColor = UIColor.grayColor()
            sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
        
    }
    
    func setButtonColor(button: UIButton, date: NSDate) {
        if date == currentDate {
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(UIColor.redColor(), forState: .Normal)
        }
        else {
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(UIColor.grayColor(), forState: .Normal)
        }
    }
    
}

protocol CustomWeekViewDelegate {
    
    func dateSelected(selectedDate: NSDate)
    
}

















