//
//  RecommendationsListViewController.swift
//  iXplore
//
//  Created by Alexander Ge on 7/18/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit
import Foundation

class RecommendationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mapButton: UIButton!
    
    var recTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recTableView.frame = CGRectMake(0, 72, UIApplication.sharedApplication().keyWindow!.frame.width, UIApplication.sharedApplication().keyWindow!.frame.height - 72)
        
        self.view.addSubview(recTableView)
        
        mapButton.layer.cornerRadius = 5
        mapButton.layer.borderWidth = 1
        mapButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        
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
//        appDelegate.recommendationsNavigationController?.popViewControllerAnimated(true)
        
//        print(appDelegate.recommendationsNavigationController?.viewControllers)
    }
    
    @IBAction func menuButtonTapped(sender: UIButton) {
        
        self.slideMenuController()?.openLeft()
    }
    
    func populateRecommendations(recommendations: [CustomGMSMarker]) {
        
        recTableView.reloadData()
        
    }
    
    // MARK: UITableView functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        print(RecommendationController.sharedInstance.fullList.count)
        return RecommendationController.sharedInstance.fullList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return RecommendationController.sharedInstance.fullList[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RecCell") as! RecommendationsTableViewCell
        
        cell.marker = RecommendationController.sharedInstance.fullList[indexPath.section][indexPath.row]
        cell.setupRatingView()
        cell.setupPriceView()
        cell.setupNameLabel()
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let float: CGFloat = 35
        return float
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 35))
        // - 2 * whiteSpace from cell
        let title = UILabel(frame: CGRectMake(5, 5, (tableView.frame.width - 10), (35 - 10)))
        
        title.font = UIFont(name: "Lato-Bold", size: 18)
        
        
        switch section {
        case 0:
            title.text = "Restaurants"
        case 1:
            title.text = "Cafes"
        case 2:
            title.text = "Bars"
        case 3:
            title.text = "Clubs"
        case 4:
            title.text = "Cultural Hotspots"
        case 5:
            title.text = "Sights"
        case 6:
            title.text = "Markets"
        default:
            title.text = "Extras"
        }
        
        header.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        header.addSubview(title)
        
        return header
        
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
    
}








