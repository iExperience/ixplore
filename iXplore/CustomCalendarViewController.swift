//
//  CustomCalendarViewController.swift
//  iXplore
//
//  Created by Alexander Ge on 7/7/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class CustomCalendarViewController: UIViewController, CustomWeekViewDelegate, CustomEventViewDelegate {

    var currentDate : NSDate!
    var dateLabel: UILabel!
    var weekStartDate : NSDate!
    var previousWeekStartDate : NSDate!
    var nextWeekStartDate : NSDate!
    var calendar : NSCalendar!
    var selectedDate: NSDate!
    
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
    let headerHeight: CGFloat = 70
    let weekViewBottomBufferHeight: CGFloat = 30
    let footerHeight: CGFloat = 50
    let dateLabelHeight: CGFloat = 20
    
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
        
        currentDate = NSDate()
        self.selectedDate = currentDate
        
        self.weekStartDate = self.getWeekStartDate(currentDate)
        self.previousWeekStartDate = self.getPreviousWeekStartDate()
        self.nextWeekStartDate = self.getNextWeekStartDate()
        
        self.setupWeekView()
        //        self.setupNextWeekView()
        //        self.setupPreviousWeekView()
        
        //        for (button,date) in self.weekView.dates {
        //            if date == currentDate {
        //                button.backgroundColor = UIColor.redColor()
        //                button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        //            }
        //        }
        
        self.setupDayView(currentDate)
        
        dateLabel = UILabel(frame: CGRectMake(0, headerHeight + buttonSize + ((weekViewBottomBufferHeight - dateLabelHeight) / 2), appDelegate.window!.frame.width, dateLabelHeight))
        dateLabel.textAlignment = .Center
        self.setupDateLabel()
        self.view.addSubview(dateLabel)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Calendar")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    @IBAction func menuButtonTapped(sender: UIButton) {
//        self.navigationController?.popViewControllerAnimated(true)
        
        self.slideMenuController()?.openLeft()
    }
    
    @IBAction func todayButtonTapped(sender: UIButton) {
        self.selectedDate = currentDate
        self.loadCurrentWeek()
    }
    func dateSelected(selectedDate: NSDate) {
        self.selectedDate = selectedDate
        self.setupDayView(self.selectedDate)
    }
    
    func eventViewTapped(eventView: CustomEventView) {
        let evc = EventViewController(nibName: "EventViewController", bundle: nil)
        evc.event = eventView.event
        self.navigationController?.pushViewController(evc, animated: true)
    }
    
    func setupDateLabel() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        dateLabel.text = dateFormatter.stringFromDate(selectedDate)
        dateLabel.font = UIFont(name: "Lato-Medium", size: 18)
        dateLabel.textColor = UIColor.grayColor()
    }
    
    func getDayOfWeek(date: NSDate) -> Int {
        return ((calendar?.component(.Weekday, fromDate: date))! - 1)
    }
    
    func getWeekStartDate(date: NSDate) -> NSDate {
        
        let dateInt = self.getDayOfWeek(currentDate) + 1
        
        let componentSubtract = NSDateComponents()
        componentSubtract.day = 1 - dateInt
        
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
        weekView.selectedDateTag = getDayOfWeek(selectedDate)
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
        
        self.view.userInteractionEnabled = false
        UIView.animateWithDuration(0.2, animations: {
            self.weekView.alpha = 0
            }, completion: {(true) in
                self.weekView.removeFromSuperview()
                self.weekStartDate = self.getPreviousWeekStartDate()
                self.nextWeekStartDate = self.getNextWeekStartDate()
                self.previousWeekStartDate = self.getPreviousWeekStartDate()
                self.setupWeekView()
                self.weekView.alpha = 0
                self.view.addSubview(self.weekView)
                self.selectedDate = self.weekView.dates[self.getDayOfWeek(self.selectedDate)].1
                self.setupDayView(self.selectedDate)
                UIView.animateWithDuration(0.2, animations: {
                    self.weekView.alpha = 1
                    }, completion: {(true) in
                        self.view.userInteractionEnabled = true
                })
        })
        
    }
    
    func loadNextWeek() {
        
        self.view.userInteractionEnabled = false
        UIView.animateWithDuration(0.2, animations: {
            self.weekView.alpha = 0
            }, completion: {(true) in
                self.weekView.removeFromSuperview()
                self.weekStartDate = self.getNextWeekStartDate()
                self.nextWeekStartDate = self.getNextWeekStartDate()
                self.previousWeekStartDate = self.getPreviousWeekStartDate()
                self.setupWeekView()
                self.weekView.alpha = 0
                self.view.addSubview(self.weekView)
                self.selectedDate = self.weekView.dates[self.getDayOfWeek(self.selectedDate)].1
                self.setupDayView(self.selectedDate)
                UIView.animateWithDuration(0.2, animations: {
                    self.weekView.alpha = 1
                    }, completion: {(true) in
                        self.view.userInteractionEnabled = true
                })
        })
        
    }
    
    func loadCurrentWeek() {
        
        self.view.userInteractionEnabled = false
        UIView.animateWithDuration(0.2, animations: {
            self.weekView.alpha = 0
            }, completion: {(true) in
                self.weekView.removeFromSuperview()
                self.weekStartDate = self.getWeekStartDate(self.selectedDate)
                self.nextWeekStartDate = self.getNextWeekStartDate()
                self.previousWeekStartDate = self.getPreviousWeekStartDate()
                self.setupWeekView()
                self.weekView.alpha = 0
                self.view.addSubview(self.weekView)
                self.setupDayView(self.selectedDate)
                UIView.animateWithDuration(0.2, animations: {
                    self.weekView.alpha = 1
                    }, completion: {(true) in
                        self.view.userInteractionEnabled = true
                })
        })
        
    }
    
    func setupDayView(date: NSDate) {
        
        if let _ = dayView {
            self.view.userInteractionEnabled = false
            UIView.animateWithDuration(0.2, animations: {
                self.dayView!.alpha = 0
                self.dateLabel.alpha = 0
                }, completion: {(true) in
                    self.dayView!.removeFromSuperview()
                    self.setupDayViewHelp(date)
                    self.dayView!.alpha = 0
                    self.view.addSubview(self.dayView!)
                    self.setupDateLabel()
                    UIView.animateWithDuration(0.2, animations: {
                        self.dayView!.alpha = 1
                        self.dateLabel.alpha = 1
                        }, completion: {(true) in
                            self.view.userInteractionEnabled = true
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
        self.loadEvents()
    }
    
    func loadEvents() {
        
//        let event1 = Event(title: "hey", startDateString: "2016-07-08T09:30:00+00:00", endDateString: "2016-07-08T10:30:00+00:00")
//                let event2 = Event(title: "hey", startDateString: "2016-07-08T09:50:00+00:00", endDateString: "2016-07-08T10:50:00+00:00")
//                let event3 = Event(title: "hey", startDateString: "2016-07-08T10:05:00+00:00", endDateString: "2016-07-08T10:55:00+00:00")
//                self.eventListComplete([event1, event2, event3])
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.stringFromDate(self.dayView!.date)
        
        let webService = WebService()
        
        let request = webService.createMutableAnonRequest(NSURL(string: "https://api.teamup.com/ks1b61e773b115d98d/events?tz=UTC&startDate=\(dateString)&endDate=\(dateString)"), method: "GET", parameters: nil, headers: ["Teamup-Token": "cda8c60dd507aa16f22f19e900799b732356ef63d825c0bee56fd98abee67f97"])
        
        webService.executeRequest(request, presentingViewController: nil, requestCompletionFunction: {(responseCode, json) in
            
            if responseCode / 100 == 2 {
                
                var events: [Event] = []
                var allDayEvents: [(String, [String])] = []
                
                for (_,event) in json["events"] {
                    var ids: [String] = []
                    for (_,id) in event["subcalendar_ids"] {
                        ids.append(id.stringValue)
                    }
                    if event["all_day"] {
                        allDayEvents.append((event["title"].stringValue, ids))
                    }
                    else {
                        events.append(Event(title: event["title"].stringValue, description: event["notes"].stringValue, who: event["who"].stringValue, location: event["location"].stringValue, startDateString: event["start_dt"].stringValue, endDateString: event["end_dt"].stringValue, subIds: ids))
                    }
                }
                
                self.eventListComplete(events, loadedAllDayEvents: allDayEvents)
            }
            else {
                print("Didn't Work")
            }
            
        })
        
    }
    
    func eventListComplete(loadedEvents: [Event], loadedAllDayEvents: [(String, [String])]) {
        for newEvent in loadedEvents {
            let newEventView = CustomEventView()
            newEventView.eventDelegate = self
            newEventView.event = newEvent
            newEventView.indent = dayView!.indentAmount
            for eventView in dayView!.eventViews {
                if eventView.event.endDate.compare(newEvent.startDate) == .OrderedDescending {
                    if withinHalfHour(eventView.event.startDate, compareDate: newEvent.startDate) {
                        if eventView.positionInConflicts == newEventView.positionInConflicts {
                            eventView.numberOfConflicts += 1
                            newEventView.positionInConflicts += 1
                        }
                        newEventView.numberOfConflicts = eventView.numberOfConflicts
                        newEventView.indent = eventView.indent
                    }
                    else {
                        newEventView.indent = eventView.indent + dayView!.indentAmount
                    }
                }
            }
            dayView!.eventViews.append(newEventView)
        }
        dayView!.allDayEvents = loadedAllDayEvents
        dayView!.displayEvents()
    }
    
    func withinHalfHour(fromDate: NSDate, compareDate: NSDate) -> Bool {
        let halfHourComponent = NSDateComponents()
        halfHourComponent.minute = 30
        let halfHourDate = calendar?.dateByAddingComponents(halfHourComponent, toDate: fromDate, options: .MatchStrictly)
        if halfHourDate?.compare(compareDate) == .OrderedDescending {
            return true
        }
        return false
    }

}