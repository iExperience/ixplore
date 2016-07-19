//
//  RecommendationsTableViewCell.swift
//  iXplore
//
//  Created by Alexander Ge on 7/19/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class RecommendationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var priceView: UIView!
    
    let picDim: CGFloat = 20
    let verticalWhiteSpace: CGFloat = 5
    let horizontalWhiteSpace: CGFloat = 5
    
    let cellWidth: CGFloat = UIApplication.sharedApplication().keyWindow!.frame.width
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.frame = CGRectMake(0, 0, cellWidth, (picDim * 2) + (verticalWhiteSpace * 3))
        
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupRatingView(marker: CustomGMSMarker) {
        
        self.ratingView.frame = CGRectMake(cellWidth - (5 * picDim) - horizontalWhiteSpace, verticalWhiteSpace, 5 * picDim, picDim)
        
        for i in 0...4 {
            let star = UIImageView()
            let e: CGFloat = CGFloat(i)
            star.frame = CGRectMake(e * picDim, 0, picDim, picDim)
            if i < marker.rating {
                star.image = UIImage(named: "star.png")
            }
            self.ratingView.addSubview(star)
        }
        self.addSubview(ratingView)
        
    }
    
    func setupPriceView(marker: CustomGMSMarker) {
        
        self.priceView.frame = CGRectMake(cellWidth - (5 * picDim) - horizontalWhiteSpace, verticalWhiteSpace * 2 + picDim, 5 * picDim, picDim)
        
        for i in 0...4 {
            let dollar = UIImageView()
            let e: CGFloat = CGFloat(i)
            dollar.frame = CGRectMake(e * picDim, 0, picDim, picDim)
            if i < marker.price {
                dollar.image = UIImage(named: "dollar.png")
            }
            self.priceView.addSubview(dollar)
        }
        self.addSubview(priceView)
        
    }
    
    func setupNameLabel(marker: CustomGMSMarker) {
        
        self.nameLabel.frame = CGRectMake(horizontalWhiteSpace, verticalWhiteSpace, cellWidth - (5 * picDim) - (horizontalWhiteSpace * 3), picDim * 2 + verticalWhiteSpace)
        
        self.nameLabel.text = marker.name
        self.addSubview(self.nameLabel)
        
    }

    
}










