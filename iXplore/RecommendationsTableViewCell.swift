//
//  RecommendationListTableViewCell.swift
//  iXplore
//
//  Created by Alexander Ge on 7/18/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class RecommendationListTableViewCell: UITableViewCell {
    
    var ratingView: UIView!
    var priceView: UIView!
    var titleLabel: UIView!
    
    let picDim: CGFloat = 20
    let verticalWhiteSpace: CGFloat = 5
    let horizontalWhiteSpace: CGFloat = 5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.frame = CGRectMake(0, 0, UIApplication.sharedApplication().keyWindow!.frame.width, (picDim * 2) + (verticalWhiteSpace * 3))
        
        self.ratingView = UIView(frame: CGRectMake(self.frame.width - (5 * picDim) - horizontalWhiteSpace, verticalWhiteSpace, 5 * picDim, picDim))
        self.priceView = UIView(frame: CGRectMake(self.frame.width - (5 * picDim) - horizontalWhiteSpace, verticalWhiteSpace * 2 + picDim, 5 * picDim, picDim))
        self.titleLabel = UILabel(frame: CGRectMake(horizontalWhiteSpace, verticalWhiteSpace, self.frame.width - (5 * picDim) - (horizontalWhiteSpace * 3), picDim * 2 + verticalWhiteSpace))
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupRatingView(rating: Int) {
        
        for i in 0...4 {
            let star = UIImageView()
            let e: CGFloat = CGFloat(i)
            star.frame = CGRectMake(e * picDim, 0, picDim, picDim)
            if i < rating {
                star.image = UIImage(named: "star.png")
            }
            self.ratingView.addSubview(star)
        }
        self.addSubview(ratingView)
        
    }
    
    func setupPriceView(price: Int) {
        
        for i in 0...4 {
            let dollar = UIImageView()
            let e: CGFloat = CGFloat(i)
            dollar.frame = CGRectMake(e * picDim, 0, picDim, picDim)
            if i < price {
                dollar.image = UIImage(named: "dollar.png")
            }
            self.priceView.addSubview(dollar)
        }
        self.addSubview(priceView)
        
    }
    
}













