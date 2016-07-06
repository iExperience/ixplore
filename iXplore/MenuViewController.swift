//
//  MenuViewController.swift
//  iXplore
//
//  Created by Brian Ge on 7/4/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class MenuViewController: UIViewController {

    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var newsletterButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let user = UserController.sharedInstance.user {
            self.nameLabel.text = user.firstName + " " + user.lastName
        }
        self.calendarButton.layer.cornerRadius = 62.5
        self.calendarButton.backgroundColor = UIColor(netHex: 0xf9007a)
        self.supportButton.layer.cornerRadius = 62.5
        self.supportButton.backgroundColor = UIColor(netHex: 0xf9007a)
        self.newsletterButton.layer.cornerRadius = 62.5
        self.newsletterButton.backgroundColor = UIColor(netHex: 0xf9007a)
        self.logoutButton.layer.cornerRadius = 62.5
        self.logoutButton.backgroundColor = UIColor(netHex: 0xf9007a)
        pictureImageView.clipsToBounds = true
        pictureImageView.image = UserController.sharedInstance.user?.image.image
        pictureImageView.layer.cornerRadius = 75
        while pictureImageView.image == nil {
            self.refreshImage()
        }
    }
    
    func refreshImage() {
        pictureImageView.clipsToBounds = true
        pictureImageView.image = UserController.sharedInstance.user?.image.image
        pictureImageView.layer.cornerRadius = 75
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(true)
//        pictureImageView.clipsToBounds = true
//        pictureImageView.image = UserController.sharedInstance.user?.image.image
//        pictureImageView.layer.cornerRadius = 75
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func calendarButtonTapped(sender: UIButton) {
        let cvc = CalendarViewController(nibName: "CalendarViewController", bundle: nil)
        self.navigationController?.pushViewController(cvc, animated: true)
    }

    @IBAction func newsletterButtonTapped(sender: UIButton) {
        let nvc = NewsViewController(nibName: "NewsViewController", bundle: nil)
        self.navigationController?.pushViewController(nvc, animated: true)
    }
    
    @IBAction func supportButtonTapped(sender: UIButton) {
        let svc = SupportViewController(nibName: "SupportViewController", bundle: nil)
        self.navigationController?.pushViewController(svc, animated: true)
    }

    @IBAction func logoutButtonTapped(sender: UIButton) {
        FBSDKLoginManager().logOut()
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.navigateToLogin()
    }
    
}
