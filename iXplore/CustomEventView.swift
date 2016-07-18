//
//  CustomEventView.swift
//  iXplore
//
//  Created by Brian Ge on 7/8/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import Foundation
import UIKit

class CustomEventView: UIView {
    
    var delegate: CustomEventViewDelegate?
    
    var titleLabel: UILabel!
    var event: Event!
    var indent: CGFloat!
    var numberOfConflicts: Int = 0
    var positionInConflicts: Int = 0
    
    func loadView() {
        
        self.clipsToBounds = true
//        self.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.1)
        self.backgroundColor = UIColor(netHex: 0xe32181).colorWithAlphaComponent(0.2)
        self.layer.cornerRadius = 8
        titleLabel = UILabel(frame: CGRectMake(5, 5, self.frame.width, 20))
        titleLabel.text = event.title
        titleLabel.font = UIFont(name: "Lato-Regular", size: 15)
        titleLabel.textColor = UIColor(netHex: 0xe32181)
        self.addSubview(titleLabel)
        
        let borderView = UIView(frame: CGRectMake(0, 0, 1, self.frame.height))
        borderView.backgroundColor = UIColor(netHex: 0xe32181)
        self.addSubview(borderView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func tapped() {
        self.delegate!.eventViewTapped(self)
    }
    
}

protocol CustomEventViewDelegate {
    func eventViewTapped(eventView: CustomEventView)
}