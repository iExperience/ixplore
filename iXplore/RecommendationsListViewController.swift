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
    
    var recTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recTableView.frame = CGRectMake(0, 72, UIApplication.sharedApplication().keyWindow!.frame.width, UIApplication.sharedApplication().keyWindow!.frame.height - 72)
        
        self.view.addSubview(recTableView)
        
        // Do any additional setup after loading the view.
        recTableView.delegate = self
        recTableView.dataSource = self
        recTableView.registerClass(RecommendationsTableViewCell.self, forCellReuseIdentifier: "RecCell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mapButtonTapped(sender: UIButton) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.recommendationsNavigationController?.setViewControllers([appDelegate.rmvc], animated: true)
        
        print(appDelegate.recommendationsNavigationController?.viewControllers)
    }
    
    @IBAction func menuButtonTapped(sender: UIButton) {
        
        self.slideMenuController()?.openLeft()
    }
    
    func populateRecommendations(recommendations: [CustomGMSMarker]) {
        
        recTableView.reloadData()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RecCell") as! RecommendationsTableViewCell

        cell.marker = RecommendationController.sharedInstance.fullList[indexPath.section][indexPath.row]
        cell.setupRatingView()
        cell.setupPriceView()
        cell.setupNameLabel()
        
        print("hi")
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("hi there")
        return RecommendationController.sharedInstance.fullList[section].count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Restaurants"
        case 1:
            return "Cafes"
        case 2:
            return "Bars"
        case 3:
            return "Clubs"
        case 4:
            return "Cultural Hotspots"
        case 5:
            return "Sights"
        case 6:
            return "Markets"
        default:
            return "Extras"
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let float: CGFloat = 55
        return float
        //(picDim * 2) + (verticalWhiteSpace * 3)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let rvc = RecommendationViewController(nibName: "RecommendationViewController", bundle: nil)
        rvc.recommendation = RecommendationController.sharedInstance.fullList[indexPath.section][indexPath.row]
        self.navigationController?.pushViewController(rvc, animated: true)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return RecommendationController.sharedInstance.fullList.count
    }
    
}








