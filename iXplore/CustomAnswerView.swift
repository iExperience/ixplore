//
//  CustomAnswerView.swift
//  iXplore
//
//  Created by Brian Ge on 7/19/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class CustomAnswerView: UIView {

    var delegate: CustomAnswerViewDelegate?
    
    var label: UILabel?
    
    var answer: String!
    var correct: Bool!
    
//    override func drawTextInRect(rect: CGRect) {
//        let insets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
//        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
//    }
    
    func loadView() {
        
        self.label = UILabel(frame: CGRectMake(5, 5, self.frame.width - 10, self.frame.height - 10))
        
        self.label!.numberOfLines = 0
        self.label!.font = UIFont(name: "Lato-Regular", size: 16)
        self.label!.text = answer
        self.label!.sizeToFit()
        self.label!.frame.size.width = self.frame.width - 10
        if self.label!.frame.height > self.frame.height - 10 {
            self.frame.size.height = self.label!.frame.height + 10
        }
        self.addSubview(self.label!)
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 2
        self.layer.shadowRadius = 3
        self.userInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func tapped(gestureRecognizer: UITapGestureRecognizer) {
        print("Tapped")
        self.delegate!.answerTapped(self.correct)
    }

}

protocol CustomAnswerViewDelegate {
    
    func answerTapped(correct: Bool)
    
}
