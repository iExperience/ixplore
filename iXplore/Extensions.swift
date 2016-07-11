//
//  Extensions.swift
//  ThriftBid
//
//  Created by Brian Ge on 6/23/16.
//  Copyright © 2016 Brian Ge. All rights reserved.
//

import Foundation
import UIKit

public let LOADING_OVERLAY_VIEW_TAG = 987432

extension UIViewController  {
    
    // MARK: Loading screen actions
    func addLoadingOverlay()   {
        
        self.makeViewDropKeyboard()
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.userInteractionEnabled = false
        
        //add an overlay screen
        let overlayImage = UIImageView(frame: (appDelegate.window?.frame)!)
        overlayImage.backgroundColor = UIColor.blackColor()
        overlayImage.alpha = 0.5
        overlayImage.tag = LOADING_OVERLAY_VIEW_TAG
        
        let loadingSpinner = UIActivityIndicatorView(frame: overlayImage.frame)
        loadingSpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        loadingSpinner.startAnimating()
        overlayImage.addSubview(loadingSpinner)
        
        
        return appDelegate.window!.addSubview(overlayImage)
    }
    
    func removeLoadingOverlay()  {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        for view in appDelegate.window!.subviews  {
            if (view.tag == LOADING_OVERLAY_VIEW_TAG)   {
                view.removeFromSuperview()
            }
        }
        appDelegate.window?.userInteractionEnabled = true
        
        
    }
    
    func makeViewDropKeyboard()   {
        //print("makeViewDropTapped")
        self.view.endEditing(true);
        self.resignFirstResponder()
    }
    
}

// extneded ways to initialize UIColor
extension UIColor {
    
    // rgb specification
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    // hex specification, netHex as hexidecimal int
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UIImageView {
    
    // get image from URL
    public func imageFromUrl(urlString: String, completion: ()->()) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                    completion()
                }
            }
        }
    }
    
}









