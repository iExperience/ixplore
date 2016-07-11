//
//  LoginViewController.swift
//  iXplore
//
//  Created by Brian Ge on 7/4/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    
    var fbloginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // darkens the background image so that the white text pops more
        self.overlayView.alpha = 0.15
        
        // layout facebook login button
        fbloginButton = FBSDKLoginButton()
        fbloginButton.center = self.view.center
        fbloginButton.delegate = self
        fbloginButton.readPermissions = ["public_profile", "email"]
        self.view.addSubview(fbloginButton)

    }
    
    override func viewDidLayoutSubviews() {
        fbloginButton.center = self.view.center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        //print(FBSDKAccessToken.currentAccessToken().userID)
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.loginUser()
        }
        else {
            let alert = UIAlertController(title: "Login Failed!", message: "Please try again.", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "Close", style: .Default, handler: nil)
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: {(alert) in self.loginButtonDidLogOut(self.fbloginButton)})
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        FBSDKLoginManager().logOut()
        return
    }

}











