//
//  AppDelegate.swift
//  iXplore
//
//  Created by Brian Ge on 7/4/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainNavigationController: UINavigationController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
//        for family: String in UIFont.familyNames()
//        {
//            print("\(family)")
//            for names: String in UIFont.fontNamesForFamilyName(family)
//            {
//                print("== \(names)")
//            }
//        }
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            print(FBSDKAccessToken.currentAccessToken())
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, first_name, last_name, picture.type(large)"])
            graphRequest.startWithCompletionHandler({
                (connection, result, error: NSError!) -> Void in
                if error == nil {
                    
                    let imageView = UIImageView()
                    imageView.imageFromUrl("http://graph.facebook.com/\(result["id"] as! String)/picture?width=720&height=720")
                    
                    UserController.sharedInstance.user = User(id: result["id"] as! String, image: imageView, firstName: result["first_name"] as! String, lastName: result["last_name"] as! String)
                }
                
            })
            let mvc = MenuViewController(nibName: "MenuViewController", bundle: nil)
            let cvc = CalendarViewController(nibName: "CalendarViewController", bundle: nil)
            self.mainNavigationController = UINavigationController(rootViewController: mvc)
            self.mainNavigationController?.pushViewController(cvc, animated: false)
            self.mainNavigationController?.navigationBarHidden = true
            self.window?.rootViewController = self.mainNavigationController
        }
        
        else {
        
            let lvc = LoginViewController(nibName: "LoginViewController", bundle: nil)
            
            self.window?.rootViewController = lvc
            
        }
        
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func navigateToLogin() {
        let lvc = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.window?.rootViewController = lvc
        self.mainNavigationController?.popViewControllerAnimated(false)
    }

}

