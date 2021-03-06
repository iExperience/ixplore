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
    var selectedDateTag: Int!
    var startDate: NSDate!
    var dates: [(UIButton,NSDate)] = []
    var currentDate: NSDate!
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
            button.layer.masksToBounds = true
            button.clipsToBounds = true
            
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
        
        let (selectedButton, selectedDate) = dates[selectedDateTag]
        self.setSelectedButtonColor(selectedButton, date: selectedDate)
        
    }
    
    func dateButtonTapped(sender: UIButton) {
        
        for (button, date) in dates {
            self.setButtonColor(button, date: date)
        }
        
        let (tappedButton,tappedDate) = dates[sender.tag]
        self.delegate?.dateSelected(tappedDate)
        self.setSelectedButtonColor(sender, date: tappedDate)
        
        self.selectedDateTag = tappedButton.tag
        
    }
    
    func setButtonColor(button: UIButton, date: NSDate) {
        if date == currentDate {
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(UIColor(netHex: 0xE32181), forState: .Normal)
        }
        else {
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(UIColor.grayColor(), forState: .Normal)
        }
    }
    
    func setSelectedButtonColor(button: UIButton, date: NSDate) {
        if date == currentDate {
            button.backgroundColor = UIColor(netHex: 0xE32181)
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
        else {
            button.backgroundColor = UIColor.grayColor()
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
    }
    
}

protocol CustomWeekViewDelegate {
    
    func dateSelected(selectedDate: NSDate)
    
}

















