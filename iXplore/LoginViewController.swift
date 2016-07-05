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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let fbloginButton = FBSDKLoginButton()
        fbloginButton.center = self.view.center
        fbloginButton.delegate = self
        fbloginButton.readPermissions = ["public_profile", "email"]
        self.view.addSubview(fbloginButton)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        //print(FBSDKAccessToken.currentAccessToken().userID)
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, first_name, last_name"])
            graphRequest.startWithCompletionHandler({
                (connection, result, error: NSError!) -> Void in
                if error == nil {
                    print(result)
                }
            })
            let mvc = MenuViewController(nibName: "MenuViewController", bundle: nil)
            let cvc = CalendarViewController(nibName: "CalendarViewController", bundle: nil)
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.mainNavigationController = UINavigationController(rootViewController: mvc)
            appDelegate.mainNavigationController?.pushViewController(cvc, animated: false)
            appDelegate.mainNavigationController?.navigationBarHidden = true
            appDelegate.window?.rootViewController = appDelegate.mainNavigationController

        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        FBSDKLoginManager().logOut()
        
        return
    }

}
