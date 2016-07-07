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
    
    var date: NSDate!
    var titleHeight: CGFloat!
    var titleWidth: CGFloat!
    var blockHeight: CGFloat!
    var titleLeadingWhiteSpace: CGFloat!
    var lineLeadingWhiteSpace: CGFloat!
    var lineTrailingWhiteSpace: CGFloat!
    
    func loadView() {
        
        var titleY = titleHeight! / 2
        var lineY = titleHeight!
        
        for i in 0...24 {
            let line = UIView(frame: CGRectMake(lineLeadingWhiteSpace + titleLeadingWhiteSpace + titleWidth, lineY, self.frame.width - titleLeadingWhiteSpace - titleWidth - lineLeadingWhiteSpace - lineTrailingWhiteSpace, 1))
            line.backgroundColor = UIColor.lightGrayColor()
            
            let title = UILabel(frame: CGRectMake(titleLeadingWhiteSpace, titleY, titleWidth, titleHeight))
            title.font = UIFont(name: "Lato-Thin", size: 12)
            title.textAlignment = .Right
//            title.textColor = UIColor.lightTextColor()
            title.text = String(i) + ":00  "
            
            self.addSubview(line)
            self.addSubview(title)
            
            titleY += blockHeight
            lineY += blockHeight
        }
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        let dateComponents = calendar?.components([.Month, .Day, .Year, .Hour, .Minute, .Weekday], fromDate: date)
        print(dateComponents!)
        
    }
    
}
