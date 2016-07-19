//
//  RecommendationsListViewController.swift
//  iXplore
//
//  Created by Alexander Ge on 7/18/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class RecommendationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recommendationsTableView: UITableView!
    
    var fullList: [CustomGMSMarker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        recommendationsTableView.delegate = self
        recommendationsTableView.dataSource = self
        recommendationsTableView.registerNib(UINib(nibName: "RecommendationsTableViewCell", bundle: nil), forCellReuseIdentifier: "RecCell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mapButtonTapped(sender: UIButton) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.recommendationsNavigationController?.setViewControllers([appDelegate.rmvc], animated: true)
    }
    
    @IBAction func menuButtonTapped(sender: UIButton) {
        
        self.slideMenuController()?.openLeft()
    }
    
    func populateRecommendations(recommendations: [CustomGMSMarker]) {
        
        for recommendation in recommendations {
            fullList.append(recommendation)
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let rvc = RecommendationViewController(nibName: "RecommendationViewController", bundle: nil)
        rvc.recommendation = fullList[indexPath.row]
        self.navigationController?.pushViewController(rvc, animated: true)
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let float: CGFloat = 55
        return float
        //(picDim * 2) + (verticalWhiteSpace * 3)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RecCell") as! RecommendationsTableViewCell
//        cell.delegate = self
//        cell.index = indexPath.row
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fullList.count
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell1 = cell as! RecommendationsTableViewCell
        let recommendation = fullList[indexPath.row]
        cell1.setupNameLabel(recommendation)
        cell1.setupPriceView(recommendation)
        cell1.setupNameLabel(recommendation)
    
    }
}








