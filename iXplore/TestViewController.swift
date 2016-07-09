//
//  TestViewController.swift
//  iXplore
//
//  Created by Brian Ge on 7/4/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    @IBOutlet var constraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func keyboardWillShow(notif: NSNotification) {
        self.keyboardVisible(notif)
    }
    
    func keyboardWillHide(notif: NSNotification) {
        self.keyboardHidden(notif)
    }
    
    func dismiss() {
        self.view.endEditing(true)
    }
    
    func keyboardVisible(notif: NSNotification) {
        if let userInfo = notif.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
                self.textView.layoutIfNeeded()
                UIView.animateWithDuration(1, animations: {
                    self.constraint.constant += keyboardHeight
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func keyboardHidden(notif: NSNotification) {
        if let userInfo = notif.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
                self.textView.layoutIfNeeded()
                UIView.animateWithDuration(1, animations: {
                    self.constraint.constant = 100
                    self.textView.layoutIfNeeded()
                })
            }
        }
    }
    
    
    

}
