//
//  CustomInfoView.swift
//  iXplore
//
//  Created by Alexander Ge on 7/18/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class CustomInfoView: UIView {

    let title = UILabel()
    let ratingView = UIView()
    let priceView = UIView()
    
    let whiteSpace: CGFloat = 5
    
    init(title: String, rating: Int, price: Int, width: CGFloat) {
        
        super.init(frame: CGRectMake(0, 0, width, ((width / 5) * 3) + (2 * whiteSpace)))
        self.backgroundColor = UIColor.whiteColor()
        setupTitle(title)
        setupRatingView(rating)
        setupPriceView(price)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTitle(title: String) {
        
        self.title.frame = CGRectMake(0, 0, self.frame.width, ((self.frame.height - (2 * whiteSpace)) / 3))
        self.title.text = title
        self.title.textColor = UIColor.blackColor()
        self.title.textAlignment = NSTextAlignment.Left
        self.addSubview(self.title)
        
    }
    
    func setupRatingView(rating: Int) {
        
        self.ratingView.frame = CGRectMake(0, ((self.frame.height - (2 * whiteSpace)) / 3) + whiteSpace, self.frame.width, ((self.frame.height - (2 * whiteSpace)) / 3))
        for i in 0...4 {
            let star = UIImageView()
            let e: CGFloat = CGFloat(i)
            star.frame = CGRectMake(e * (self.ratingView.frame.width / 5), 0, self.ratingView.frame.width / 5, self.ratingView.frame.width / 5)
            if i < rating {
                star.image = UIImage(named: "star.png")
            }
            self.ratingView.addSubview(star)
        }
        self.addSubview(ratingView)
        
    }
    
    func setupPriceView(price: Int) {
        
        self.priceView.frame = CGRectMake(0, ((self.frame.height - (2 * whiteSpace)) / 3) * 2 + (2 * whiteSpace), self.frame.width, ((self.frame.height - (2 * whiteSpace)) / 3))
        for i in 0...4 {
            let dollar = UIImageView()
            let e: CGFloat = CGFloat(i)
            dollar.frame = CGRectMake(e * (self.ratingView.frame.width / 5), 0, self.ratingView.frame.width / 5, self.ratingView.frame.width / 5)
            if i < price {
                dollar.image = UIImage(named: "dollar.png")
            }
            self.priceView.addSubview(dollar)
        }
        self.addSubview(priceView)

    }
    

}
















