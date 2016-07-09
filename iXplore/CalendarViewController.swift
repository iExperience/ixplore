//
//  CalendarViewController.swift
//  iXplore
//
//  Created by Brian Ge on 7/4/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit
import WebKit

class CalendarViewController: UIViewController , WKNavigationDelegate {
    
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
        
//        let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=100; minimum-scale=1.0; maximum-scale=1.0'); document.getElementsByTagName('head')[0].appendChild(meta);"
//        let wkUScript = WKUserScript(source: jScript, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
//        let wkUController = WKUserContentController()
//        wkUController.addUserScript(wkUScript)
//        let wkWebConfig = WKWebViewConfiguration()
//        wkWebConfig.userContentController = wkUController
        
//        self.webView = WKWebView(frame: CGRectMake(0, 60, (appDelegate.window?.frame.width)!, (appDelegate.window?.frame.height)! - 60), configuration: wkWebConfig)
//        self.webView?.contentScaleFactor = 1
        self.webView = WKWebView()
        self.webView?.navigationDelegate = self
        self.webView?.frame = CGRectMake(0, 60, (appDelegate.window?.frame.width)!, (appDelegate.window?.frame.height)! - 60)
//        self.webView?.contentMode = UIViewContentMode.ScaleAspectFit
        let url = NSURL(string:"https://teamup.com/ks1b61e773b115d98d?view=w")
        let req = NSURLRequest(URL:url!)
        self.webView!.loadRequest(req)
//        self.webView?.frame = CGRectMake(0, 60, (appDelegate.window?.frame.width)!, (appDelegate.window?.frame.height)! - 60)
//        while webView!.loading {
//            print("hey")
//        }

//        self.view.addSubview(self.webView!)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        self.view.addSubview(self.webView!)
//        let contentSize = self.webView?.scrollView.contentSize
//        let viewSize = self.webView?.bounds.size
//        print(contentSize?.width)
//        print(viewSize?.width)
//        let rw = (viewSize?.width)! / (contentSize?.width)!
//        print(rw)
//        self.webView!.scrollView.minimumZoomScale = rw
//        self.webView!.scrollView.maximumZoomScale = rw
//        self.webView!.scrollView.zoomScale = rw
    }

    @IBAction func menuButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
