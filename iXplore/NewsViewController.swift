//
//  NewsViewController.swift
//  iXplore
//
//  Created by Brian Ge on 7/4/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit
import WebKit

class NewsViewController: UIViewController {
    
    var webView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        super.loadView()
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.webView = WKWebView()
        self.webView?.frame = CGRectMake(0, 60, (appDelegate.window?.frame.width)!, (appDelegate.window?.frame.height)! - 60)
        self.webView?.contentMode = UIViewContentMode.ScaleAspectFit
        let url = NSURL(string:"http://ixp.co.za/notice-board")
        let req = NSURLRequest(URL:url!)
        self.webView!.loadRequest(req)
        self.view.addSubview(self.webView!)
    }

    @IBAction func menuButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
