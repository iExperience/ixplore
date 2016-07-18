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
    
    var blockHeight: CGFloat!
    var picDim: CGFloat!
    
    let lineWhiteSpace: CGFloat = 5
    let leadingWhiteSpace: CGFloat = 5
    
    init(title: String, rating: Int, price: Int, width: CGFloat) {
        
        super.init(frame: CGRectMake(0, 0, width, ((width / 5) * 3) + (3 * lineWhiteSpace)))
        
        blockHeight = ((self.frame.height - (2 * lineWhiteSpace)) / 3)
        picDim = (self.frame.width - (2 * leadingWhiteSpace)) / 5
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.borderWidth = 2
        
        setupTitle(title)
        setupRatingView(rating)
        setupPriceView(price)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTitle(title: String) {
        
        self.title.frame = CGRectMake(leadingWhiteSpace, 0, self.frame.width - 2 * leadingWhiteSpace, blockHeight)
        self.title.text = title
        self.title.textColor = UIColor.blackColor()
        self.title.textAlignment = NSTextAlignment.Left
        self.title.font = UIFont(name: "Lato-Regular", size: 18)
        self.addSubview(self.title)
        
    }
    
    func setupRatingView(rating: Int) {
        
        self.ratingView.frame = CGRectMake(0, blockHeight + lineWhiteSpace, self.frame.width, blockHeight)
        for i in 0...4 {
            let star = UIImageView()
            let e: CGFloat = CGFloat(i)
            star.frame = CGRectMake(e * picDim + leadingWhiteSpace, 0, picDim, picDim)
            if i < rating {
                star.image = UIImage(named: "star.png")
            }
            self.ratingView.addSubview(star)
        }
        self.addSubview(ratingView)
        
    }
    
    func setupPriceView(price: Int) {
        
        self.priceView.frame = CGRectMake(0, blockHeight * 2 + lineWhiteSpace * 2, self.frame.width, blockHeight)
        for i in 0...4 {
            let dollar = UIImageView()
            let e: CGFloat = CGFloat(i)
            dollar.frame = CGRectMake(e * picDim + leadingWhiteSpace, 0, picDim, picDim)
            if i < price {
                dollar.image = UIImage(named: "dollar.png")
            }
            self.priceView.addSubview(dollar)
        }
        self.addSubview(priceView)

    }
    

}
















