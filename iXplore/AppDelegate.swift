//
//  AppDelegate.swift
//  iXplore
//
//  Created by Brian Ge on 7/4/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import SlideMenuControllerSwift
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var mainNavigationController: UINavigationController?
    var recommendationsNavigationController: UINavigationController?
    
    var rmvc: RecommendationsMapViewController!
    var rlvc: RecommendationsListViewController!
    
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
        
        // Google Analytics
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        //        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
        
        // Google Maps
        GMSServices.provideAPIKey("AIzaSyC4BRmFQal3Qou4JOyCQUEPhbCnXi2TdAM")
        //        RecommendationController.sharedInstance.alamo()
        
        rmvc = RecommendationsMapViewController(nibName: "RecommendationsMapViewController", bundle: nil)
        rlvc = RecommendationsListViewController(nibName: "RecommendationsListViewController", bundle: nil)
        
        // Push notifications
        self.registerForPushNotifications(application)
        
        // Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        rmvc = RecommendationsMapViewController(nibName: "RecommendationsMapViewController", bundle: nil)
        rlvc = RecommendationsListViewController(nibName: "RecommendationsListViewController", bundle: nil)
        
        
        // Checks if user has logged-on on this device previously
        if FBSDKAccessToken.currentAccessToken() != nil {
            
            self.loginUser()
//            let qvc = QuestionViewController(nibName: "QuestionViewController", bundle: nil)
//            qvc.question = Question(question: "Yes? DO you ahve a quesiton? Because I don't and I'm really tired and don't want to think of a good question.", answers: ["yes asdfkjhb aslfkha asdfjlkj lkjasdflkjaslkdjfnalkjs lakjsdlka alksjdblkjbsdlkfjansld aldkj lkjkj kj kj  falksj asdlfkj asdflkj asdfklj  fdskj asdlkj lkasjd endinghappensnow", "no i don't like shirmp very much because it's kind of gorss and I hate gorss things because they are gross like you", "yes"], correctAnswer: 2)
//            self.window?.rootViewController = qvc
            
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
    
    // when logout menu button is pressed, go to login screen
    func navigateToLogin() {
        let lvc = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.window?.rootViewController = lvc
        self.mainNavigationController?.popViewControllerAnimated(false)
    }
    
    // allows for push notifications
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    // checks if you went into your phone settings and changed the push notification settings
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    // gets your device token for APNs API server call
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        print(deviceToken)
        print("Device Token:", tokenString)
        
        let builder = GAIDictionaryBuilder.createEventWithCategory("Device Token", action: "App Load", label: tokenString, value: nil)
        GAI.sharedInstance().defaultTracker.send(builder.build() as [NSObject: AnyObject])
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        //        print("Failed to register:", error)
    }
    
    func loginUser() {
        
        let mvc = MenuViewController(nibName: "MenuViewController", bundle: nil)
        
        let ccvc = CustomCalendarViewController(nibName: "CustomCalendarViewController", bundle: nil)
        
        // getting all recommendations from online
        RecommendationController.sharedInstance.getRecommendations(mapCompletion: rmvc.populateRecommendations, listCompletion: rlvc.populateRecommendations)
        
        // Navigation controller
        self.mainNavigationController = UINavigationController(rootViewController: ccvc)
        self.mainNavigationController?.navigationBarHidden = true
        self.recommendationsNavigationController = UINavigationController(rootViewController: rmvc!)
        self.recommendationsNavigationController?.navigationBarHidden = true
        
        // Set up slide menu
        SlideMenuOptions.leftViewWidth = (self.window?.frame.width)! * 2 / 3
        SlideMenuOptions.contentViewScale = 1
        SlideMenuOptions.hideStatusBar = false
        
        // Create slide menu controller with previous options
        let smc = SlideMenuController(mainViewController: self.mainNavigationController!, leftMenuViewController: mvc)
        smc.view.removeGestureRecognizer(smc.leftPanGesture!)
        
        self.window?.rootViewController = smc
        
        self.loadFacebookInfo(mvc)
        
    }
    
    func loadFacebookInfo(menu: MenuViewController) {
        
        // adds loading overlay to prevent app access before all facebook information has been downloaded
        self.window?.rootViewController?.addLoadingOverlay()
        
        // get user's fb name, email, and profile picture
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, first_name, last_name, picture.type(large)"])
        
        graphRequest.startWithCompletionHandler({
            (connection, result, error: NSError!) -> Void in
            if error == nil {
                
                // pulls facebook profile picture using url
                // sets user's profile picture to the menu image
                let imageView = UIImageView()
                imageView.imageFromUrl("http://graph.facebook.com/\(result["id"] as! String)/picture?width=720&height=720", completion: menu.setImage)
                
                // sets menu's welcome title to user's name
                UserController.sharedInstance.user = User(id: result["id"] as! String, image: imageView, firstName: result["first_name"] as! String, lastName: result["last_name"] as! String)
                menu.setupName()
                GAI.sharedInstance().defaultTracker.set(kGAIUserId, value: "\(result["first_name"] as! String) \(result["last_name"] as! String)")
                let builder = GAIDictionaryBuilder.createEventWithCategory("User_Id", action: "Sign in", label: "\(result["first_name"] as! String) \(result["last_name"] as! String)", value: nil)
                GAI.sharedInstance().defaultTracker.send(builder.build() as [NSObject: AnyObject])
                
                // remove the overlay, allow access to app
                self.window?.rootViewController?.removeLoadingOverlay()
            }
            else {
                
                // remove the overlay
                self.window?.rootViewController?.removeLoadingOverlay()
                
                // create error alert message that recursively calls the function
                // no current access to app w/out internet access so no need for 'cancel' functionality
                let alert = UIAlertController(title: "Error", message: "Network connection failed. Please try again.", preferredStyle: .Alert)
                let alertAction = UIAlertAction(title: "Try Again", style: .Cancel, handler: {(alert) in self.loadFacebookInfo(menu)})
                alert.addAction(alertAction)
                self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            }
            
        })
    }
    
}