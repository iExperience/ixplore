//
//  RecommendationsListViewController.swift
//  iXplore
//
//  Created by Alexander Ge on 7/18/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class RecommendationsListViewController: UIViewController, UITableViewDelegate{//, UITableViewDataSource {
    
    @IBOutlet weak var recommendationsTableView: UITableView!
    
    @IBAction func mapButtonTapped(sender: UIButton) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.recommendationsNavigationController?.setViewControllers([appDelegate.rmvc], animated: true)
    }
    
    @IBAction func menuButtonTapped(sender: UIButton) {
        
        self.slideMenuController()?.openLeft()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateRecommendations(recommendations: [CustomGMSMarker]) {
        
    }
    
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //        <#code#>
    //    }
    //
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        <#code#>
    //    }
    //
    //    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //        <#code#>
    //    }
    //
    //    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        <#code#>
    //    }

    
}








