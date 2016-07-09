//
//  EventViewController.swift
//  iXplore
//
//  Created by Brian Ge on 7/9/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var whoLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        titleLabel.text = event!.title
        titleLabel.sizeToFit()
        descriptionTextView.attributedText = event!.description
        descriptionTextView.font = UIFont(name: "Lato-Regular", size: 16)
        descriptionTextView.sizeToFit()
        descriptionTextView.delegate = self
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        var time = dateFormatter.stringFromDate((event!.startDate)!) + ", from "
        dateFormatter.dateFormat = "HH:mm"
        time += dateFormatter.stringFromDate((event!.startDate)!) + " to "
        time += dateFormatter.stringFromDate((event!.endDate)!)
        
        timeLabel.text = time
        locationLabel.text = "Location: \(event!.location)"
        whoLabel.text = "Who: \(event!.who)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        return true
    }

}
