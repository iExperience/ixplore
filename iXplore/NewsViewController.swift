//
//  NewsViewController.swift
//  iXplore
//
//  Created by Brian Ge on 7/4/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit
import WebKit

class NewsViewController: UIViewController, WKNavigationDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    var webView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "iXDaily")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func loadView() {
        super.loadView()
        self.addLoadingOverlay()
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.webView = WKWebView()
        self.webView?.navigationDelegate = self
        self.webView?.frame = CGRectMake(0, 60, (appDelegate.window?.frame.width)!, (appDelegate.window?.frame.height)! - 60)
        let url = NSURL(string:"http://ixp.co.za/notice-board")
        let req = NSURLRequest(URL:url!)
        self.webView!.loadRequest(req)
        
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        self.view.addSubview(self.webView!)
        self.removeLoadingOverlay()
        
    }

    @IBAction func menuButtonTapped(sender: UIButton) {
        self.slideMenuController()?.openLeft()
    }

}



















