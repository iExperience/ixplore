//
//  CustomCalendarViewController.swift
//  iXplore
//
//  Created by Alexander Ge on 7/7/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class CustomCalendarViewController: UIViewController, CustomWeekViewDelegate {

    var currentDate : NSDate!
    var weekStartDate : NSDate!
    var previousWeekStartDate : NSDate!
    var nextWeekStartDate : NSDate!
    var calendar : NSCalendar!
    
    // for week view
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let whiteSpace: CGFloat = 5
    var buttonSize: CGFloat!
    var weekView: CustomWeekView!
    var nextWeekView: CustomWeekView!
    var previousWeekView: CustomWeekView!
    
    // for day view
    let blockHeight: CGFloat = 60
    let titleHeight: CGFloat = 15
    let titleWidth: CGFloat = 40
    let titleLeadingWhiteSpace: CGFloat = 0
    let lineLeadingWhiteSpace: CGFloat = 10
    let lineTrailingWhiteSpace: CGFloat = 5
    var dayView: CustomDayView?
    
    // other layout helpers
    let headerHeight: CGFloat = 60
    let weekViewBottomBufferHeight: CGFloat = 30
    let footerHeight: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buttonSize = ((appDelegate.window?.frame.width)! - (whiteSpace * 10)) / 9
    
        let backButton = UIButton(frame: CGRectMake(whiteSpace, headerHeight, buttonSize, buttonSize))
        backButton.setImage(UIImage(named: "backarrow.png"), forState: .Normal)
        backButton.addTarget(self, action: #selector(self.loadPreviousWeek), forControlEvents: .TouchUpInside)
        let nextButton = UIButton(frame: CGRectMake(appDelegate.window!.frame.width - whiteSpace - buttonSize, headerHeight, buttonSize, buttonSize))
        nextButton.setImage(UIImage(named: "nextarrow.png"), forState: .Normal)
        nextButton.addTarget(self, action: #selector(self.loadNextWeek), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(backButton)
        self.view.addSubview(nextButton)
        
        calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        calendar?.timeZone = NSTimeZone.localTimeZone()
        
        let borderView = UIView(frame: CGRectMake(0, headerHeight + weekViewBottomBufferHeight + buttonSize, appDelegate.window!.frame.width, 1))
        borderView.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(borderView)

    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        currentDate = NSDate()
        
        self.weekStartDate = self.getWeekStartDate(currentDate)
        self.previousWeekStartDate = self.getPreviousWeekStartDate()
        self.nextWeekStartDate = self.getNextWeekStartDate()
        
        self.setupWeekView()
        self.setupNextWeekView()
        self.setupPreviousWeekView()
        
        for (button,date) in self.weekView.dates {
            if date == currentDate {
                button.backgroundColor = UIColor.redColor()
                button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            }
        }
        
        self.setupDayView(currentDate)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dateSelected(selectedDate: NSDate) {
        self.setupDayView(selectedDate)
    }
    
    func getWeekStartDate(date: NSDate) -> NSDate {
        
        let dateInt = calendar?.component(.Weekday, fromDate: currentDate)
        
        let componentSubtract = NSDateComponents()
        componentSubtract.day = 1 - dateInt!
        
        return (calendar?.dateByAddingComponents(componentSubtract, toDate: date, options: .SearchBackwards))!
        
    }
    
    func getPreviousWeekStartDate() -> NSDate {
        
        let componentSubtract = NSDateComponents()
        componentSubtract.day = -7
        
        return (calendar?.dateByAddingComponents(componentSubtract, toDate: weekStartDate, options: .SearchBackwards)!)!
        
    }
    
    func getNextWeekStartDate() -> NSDate {

        let componentAdd = NSDateComponents()
        componentAdd.day = 7
        
        return (calendar?.dateByAddingComponents(componentAdd, toDate: weekStartDate, options: .MatchStrictly)!)!
        
    }
    
    func setupWeekView() {
        
        weekView = CustomWeekView(frame: CGRectMake((whiteSpace * 2) + buttonSize, headerHeight, (whiteSpace * 6) + (buttonSize * 7), buttonSize))
        weekView.delegate = self
        weekView.startDate = weekStartDate
        weekView.currentDate = currentDate
        weekView.buttonSize = buttonSize
        weekView.whiteSpace = whiteSpace
        weekView.populateDates()
        
        self.view.addSubview(weekView)
        
    }
    
    func setupNextWeekView() {
        
        nextWeekView = CustomWeekView(frame: CGRectMake((whiteSpace * 2) + buttonSize, headerHeight, (whiteSpace * 6) + (buttonSize * 7), buttonSize))
        nextWeekView.startDate = nextWeekStartDate
        nextWeekView.currentDate = currentDate
        nextWeekView.buttonSize = buttonSize
        nextWeekView.whiteSpace = whiteSpace
        nextWeekView.populateDates()
        
    }
   
    func setupPreviousWeekView() {
        
        previousWeekView = CustomWeekView(frame: CGRectMake((whiteSpace * 2) + buttonSize, headerHeight, (whiteSpace * 6) + (buttonSize * 7), buttonSize))
        previousWeekView.startDate = previousWeekStartDate
        previousWeekView.currentDate = currentDate
        previousWeekView.buttonSize = buttonSize
        previousWeekView.whiteSpace = whiteSpace
        previousWeekView.populateDates()
        
    }
    
    func loadPreviousWeek() {
        
        UIView.animateWithDuration(0.6, animations: {
            self.weekView.alpha = 0
            }, completion: {(true) in
                self.weekView.removeFromSuperview()
                self.weekStartDate = self.getPreviousWeekStartDate()
                self.nextWeekStartDate = self.getNextWeekStartDate()
                self.previousWeekStartDate = self.getPreviousWeekStartDate()
                self.setupWeekView()
                self.weekView.alpha = 0
                self.view.addSubview(self.weekView)
                UIView.animateWithDuration(0.6, animations: {
                    self.weekView.alpha = 1
                })
        })
        
    }
    
    func loadNextWeek() {
        
        UIView.animateWithDuration(0.6, animations: {
            self.weekView.alpha = 0
            }, completion: {(true) in
                self.weekView.removeFromSuperview()
                self.weekStartDate = self.getNextWeekStartDate()
                self.nextWeekStartDate = self.getNextWeekStartDate()
                self.previousWeekStartDate = self.getPreviousWeekStartDate()
                self.setupWeekView()
                self.weekView.alpha = 0
                self.view.addSubview(self.weekView)
                UIView.animateWithDuration(0.6, animations: {
                    self.weekView.alpha = 1
                    })
        })
        
    }
    
    func setupDayView(date: NSDate) {
        
        if let _ = dayView {
            UIView.animateWithDuration(0.3, animations: {
                self.dayView!.alpha = 0
                }, completion: {(true) in
                    self.dayView!.removeFromSuperview()
                    self.setupDayViewHelp(date)
                    self.dayView!.alpha = 0
                    self.view.addSubview(self.dayView!)
                    UIView.animateWithDuration(0.3, animations: {
                        self.dayView!.alpha = 1
                    })
            })
        }
        else {
            self.setupDayViewHelp(date)
            self.view.addSubview(dayView!)
        }
        
    }
    
    func setupDayViewHelp(date: NSDate) {
        
        self.dayView = CustomDayView(frame: CGRectMake(0, self.headerHeight + self.weekViewBottomBufferHeight + self.buttonSize, self.appDelegate.window!.frame.width, self.appDelegate.window!.frame.height - (self.headerHeight + self.weekViewBottomBufferHeight + self.buttonSize + self.footerHeight)))
        self.dayView!.blockHeight = self.blockHeight
        self.dayView!.titleHeight = self.titleHeight
        self.dayView!.titleWidth = self.titleWidth
        self.dayView!.titleLeadingWhiteSpace = self.titleLeadingWhiteSpace
        self.dayView!.lineLeadingWhiteSpace = self.lineLeadingWhiteSpace
        self.dayView!.lineTrailingWhiteSpace = self.lineTrailingWhiteSpace
        self.dayView!.date = date
        self.dayView!.contentSize = CGSize(width: self.dayView!.frame.width, height: (24 * self.blockHeight) + (2 * self.titleHeight))
        self.dayView!.loadView()
        
    }

}























