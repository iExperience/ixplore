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
        self.overlayView.alpha = 0.15
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
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, first_name, last_name, picture.type(large)"])
            graphRequest.startWithCompletionHandler({
                (connection, result, error: NSError!) -> Void in
//                print(result)
//                print(result["id"])
//                print(result["picture"]!!["data"]!!["url"])
                if error == nil {
                    
                    let imageView = UIImageView()
                    imageView.imageFromUrl("http://graph.facebook.com/\(result["id"] as! String)/picture?width=720&height=720")
                    
                    UserController.sharedInstance.user = User(id: result["id"] as! String, image: imageView, firstName: result["first_name"] as! String, lastName: result["last_name"] as! String)
                }
                print(UserController.sharedInstance.user)
                
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
