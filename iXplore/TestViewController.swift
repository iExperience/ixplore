//
//  TestViewController.swift
//  iXplore
//
//  Created by Brian Ge on 7/4/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let id: String = "577a7f470981ddedda000036"
        
        let description = "hello i'm brian"
        
        let category = "hey"
        
        let body: String = "Description: \(description).\nCategory: \(category).\nSubmitted by: student."
        
        let user: Dictionary<String, String> = ["type": "user", "id": id]
        
        let params: Dictionary<String, AnyObject> = ["from": user, "body": body]
        
        let server = WebService()
//        let request = server.createMutableRequest(NSURL(string:  "https://api.intercom.io/users/\(id)"), method: "GET", parameters: nil)
        let request = server.createMutableRequest(NSURL(string: "https://api.intercom.io/messages"), method: "POST", parameters: params)
        
        server.executeRequest(request, presentingViewController:self, requestCompletionFunction: {(responseCode, json) in
            
            print(json)
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
