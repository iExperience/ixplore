//
//  RecommendationViewController.swift
//  iXplore
//
//  Created by Alexander Ge on 7/18/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class RecommendationViewController: UIViewController {

    var recommendation: CustomGMSMarker!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var mustTryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = recommendation.name
        
        for i in 0..<recommendation.rating {
            let star = UIImageView(image: UIImage(named: "star.png"))
            star.frame = CGRectMake(ratingLabel.frame.origin.x + ratingLabel.frame.width + 10 + (CGFloat(i) * ratingLabel.frame.height), ratingLabel.frame.origin.y, ratingLabel.frame.height, ratingLabel.frame.height)
            self.scrollView.addSubview(star)
        }
        
        if recommendation.price == 0 {
            let free = UILabel(frame: CGRectMake(priceLabel.frame.origin.x + priceLabel.frame.width + 10, priceLabel.frame.origin.y, priceLabel.frame.width, priceLabel.frame.height))
            free.font = priceLabel.font
            free.textColor = priceLabel.textColor
            free.text = "Free"
            self.scrollView.addSubview(free)
        }
        else {
            for i in 0..<recommendation.price {
                let dollar = UIImageView(image: UIImage(named: "dollar.png"))
                dollar.frame = CGRectMake(priceLabel.frame.origin.x + priceLabel.frame.width + 10 + (CGFloat(i) * priceLabel.frame.height), priceLabel.frame.origin.y, priceLabel.frame.height, priceLabel.frame.height)
                self.scrollView.addSubview(dollar)
            }
        }
        
        infoLabel.text = recommendation.info
        
        if let mustTry = recommendation.mustTry {
            mustTryLabel.text = "Must try: \(mustTry)"
        }
        else {
            mustTryLabel.hidden = true
        }
        
        self.scrollView.contentSize.width = (UIApplication.sharedApplication().keyWindow?.frame.width)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }


}
