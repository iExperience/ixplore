//
//  SupportViewController.swift
//  iXplore
//
//  Created by Brian Ge on 7/4/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var supportPicker: UIPickerView!
    
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet var descriptionTopConstraint: NSLayoutConstraint!
    @IBOutlet var buttonBottomConstraint: NSLayoutConstraint!
    
    var topConstraint: NSLayoutConstraint?
    
    var pickerData: [[String]] = [["Housing", "housing"], ["Class", "education"], ["Professional Development", "professional development"], ["Excursions", "excursions"], ["Health and Safety", "health and safety"], ["Other", "other"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardVisible(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        
        self.supportPicker.delegate = self
        self.supportPicker.dataSource = self
        
        self.supportPicker.layer.cornerRadius = 10
        self.supportPicker.layer.borderWidth = 1
        self.supportPicker.layer.borderColor = UIColor(netHex: 0xe7eaec).CGColor
        self.descriptionField.layer.cornerRadius = 10
        self.descriptionField.layer.borderWidth = 1
        self.descriptionField.layer.borderColor = UIColor(netHex: 0xe7eaec).CGColor
        self.submitButton.layer.cornerRadius = 3
        self.submitButton.backgroundColor = UIColor(netHex: 0x1c84c6)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func submitButtonTapped(sender: UIButton) {
        let id: String = "571a025295d0428a9700001d"
        
        let description = descriptionField.text
        
        let category = pickerData[supportPicker.selectedRowInComponent(0)][1]
        
        let body: String = "Description: \(description).\n\nCategory: \(category).\n\nSubmitted by: student."
        
        let user: Dictionary<String, String> = ["type": "user", "id": id]
        
        let params: Dictionary<String, AnyObject> = ["from": user, "body": body]
        
        let server = WebService()
        //        let request = server.createMutableRequest(NSURL(string:  "https://api.intercom.io/users/\(id)"), method: "GET", parameters: nil)
        let request = server.createMutableRequest(NSURL(string: "https://api.intercom.io/messages"), method: "POST", parameters: params)
        
        server.executeRequest(request, presentingViewController:self, requestCompletionFunction: {(responseCode, json) in
            
            if responseCode / 100 == 2 {
                let alert = UIAlertController(title: "Success!", message: "Someone will be in touch with you shortly regarding your issue!", preferredStyle: .Alert)
                let alertAction = UIAlertAction(title: "Close", style: .Default, handler: {(action) in
                    self.descriptionField.text = ""
                })
                alert.addAction(alertAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        })
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return pickerData[row][0]
//    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel(frame: CGRectMake(0, 0, supportPicker.frame.width, 20))
        pickerLabel.textAlignment = .Center
        pickerLabel.backgroundColor = UIColor.clearColor()
        pickerLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        pickerLabel.text = pickerData[row][0]
        pickerLabel.textColor = UIColor(red: 68, green: 68, blue: 68)
        return pickerLabel
    }
    
//    func keyboardVisible(notif: NSNotification) {
//        print("visible")
//
//        if let userInfo = notif.userInfo {
//            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
//                UIView.animateWithDuration(2, animations: { () -> Void in
//                    self.descriptionTopConstraint.active = false
//                    self.topConstraint?.active = false
//                    self.topConstraint = NSLayoutConstraint(item: self.descriptionField, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 40 + keyboardHeight)
//                    self.topConstraint!.active = true
//                    self.view.addConstraint(self.topConstraint!)
//                    self.view.frame.origin = CGPoint(x: 0, y: -keyboardHeight)
//                    self.firstLabel.hidden = true
//                    self.supportPicker.hidden = true
//                    self.secondLabel.hidden = true
//                    self.view.layoutIfNeeded()
//                })
//            }
//        }
//    }
//
//    func keyboardHidden(notif: NSNotification) {
//        print("hidden")
//        self.firstLabel.hidden = false
//        self.supportPicker.hidden = false
//        self.secondLabel.hidden = false
//        
//        UIView.animateWithDuration(0.5, animations: { () -> Void in
//            self.view.frame.origin = CGPoint(x: 0, y: 0)
//            self.topConstraint?.active = false
//            self.descriptionTopConstraint.active = true
//            self.view.layoutIfNeeded()
//            
//        })
//    }

    func keyboardVisible(notif: NSNotification) {
        
        if let userInfo = notif.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
                self.firstLabel.hidden = true
                self.supportPicker.hidden = true
                self.secondLabel.hidden = true
                self.borderView.hidden = true
                self.headerView.hidden = true
                UIView.animateWithDuration(1, animations: {
                    self.descriptionTopConstraint.active = false
                    self.topConstraint?.active = false
                    self.topConstraint = NSLayoutConstraint(item: self.descriptionField, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 40)
                    self.topConstraint!.active = true
                    self.view.addConstraint(self.topConstraint!)
                    self.buttonBottomConstraint.constant = keyboardHeight + 30
                })
                
            }
        }

        
    }
    
    func keyboardHidden(notif: NSNotification) {
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.frame.origin = CGPoint(x: 0, y: 0)
            self.topConstraint?.active = false
            self.descriptionTopConstraint.active = true
            self.buttonBottomConstraint.constant = 30
        })
        
        self.firstLabel.hidden = false
        self.supportPicker.hidden = false
        self.secondLabel.hidden = false
        self.borderView.hidden = false
        self.headerView.hidden = false
    }
    
    func dismiss() {
        self.view.endEditing(true)
    }
    
}
