//
//  MenuViewController.swift
//  iXplore
//
//  Created by Brian Ge on 7/4/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sizeToFit()
    }
    
    func setImage() {
        pictureImageView.clipsToBounds = true
        pictureImageView.image = UserController.sharedInstance.user?.image.image
        pictureImageView.layer.cornerRadius = 75
    }
    
    func setupName() {
        if let user = UserController.sharedInstance.user {
            self.nameLabel.text = "Welcome, \(user.firstName)!"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "menuOption")
        switch indexPath.row {
        case 0: cell.textLabel?.text = "Calendar"
        case 1: cell.textLabel?.text = "iXplore"
        case 2: cell.textLabel?.text = "iXDaily"
        case 3: cell.textLabel?.text = "Support"
        case 4: cell.textLabel?.text = "Logout"
        default: break
        }
        cell.accessoryType = .DisclosureIndicator
        cell.textLabel?.font = UIFont(name: "Lato-Regular", size: 18)
        cell.textLabel?.textColor = UIColor(netHex: 0x2E3137)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let smc = self.slideMenuController() {
            switch indexPath.row {
            case 0: smc.changeMainViewController(appDelegate.mainNavigationController!, close: true)
            case 1: smc.changeMainViewController(RecommendationsMapViewController(nibName: "RecommendationsMapViewController", bundle: nil), close: true)
            case 2: smc.changeMainViewController(NewsViewController(nibName: "NewsViewController", bundle: nil), close: true)
            case 3: smc.changeMainViewController(SupportViewController(nibName: "SupportViewController", bundle: nil), close: true)
            case 4:FBSDKLoginManager().logOut()
            appDelegate.navigateToLogin()
            default: break
            }
        }
    }
    
}


















