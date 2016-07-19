//
//  QuestionViewController.swift
//  iXplore
//
//  Created by Brian Ge on 7/18/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, CustomAnswerViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var questionLabel: UILabel!
    
    var question: Question!
    
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let questionTop: CGFloat = 30
    let questionImageHeight: CGFloat = 100
    let answerLeading: CGFloat = 20
    let answerTop: CGFloat = 20
    let minimumAnswerHeight: CGFloat = 70
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionLabel.text = question.question
        questionLabel.frame.size.height = questionLabel.heightForLabel(questionLabel.text!, font: UIFont(name: "Lato-Regular", size: 20)!, width: appDelegate.window!.frame.width - questionImageHeight - 60)
        
        var answerY = max(questionLabel.frame.height, questionImageHeight) + answerTop + questionTop
        
        for i in 0..<question.answers.count {
            
            let answerLabel = CustomAnswerView(frame: CGRectMake(answerLeading, answerY, appDelegate.window!.frame.width - (answerLeading * 2), minimumAnswerHeight))
            answerLabel.answer = question.answers[i]
            answerLabel.loadView()
            answerLabel.delegate = self
            answerLabel.correct = (i == question.correctAnswer)
            self.scrollView.addSubview(answerLabel)
            answerY += answerLabel.frame.height + answerTop
            
            if i == question.answers.count - 1 {
                scrollView.contentSize.height = answerLabel.frame.origin.y + answerLabel.frame.height + 20
            }
            
        }
        
//        answerY = max(questionLabel.frame.height, questionImageHeight) + answerTop
//        let firstAnswerLabel = CustomAnswerLabel(frame: CGRectMake(answerLeading, answerY, UIApplication.sharedApplication().keyWindow!.frame.width - (answerLeading * 2), minimumAnswerHeight))
//        firstAnswerLabel.loadView()
//        firstAnswerLabel.delegate = self
//        self.scrollView.addSubview(firstAnswerLabel)
//        
//        answerY = firstAnswerLabel.frame.origin.y + firstAnswerLabel.frame.height + answerTop
//        let secondAnswerLabel = CustomAnswerLabel(frame: CGRectMake(answerLeading, answerY, UIApplication.sharedApplication().keyWindow!.frame.width - (answerLeading * 2), minimumAnswerHeight))
//        secondAnswerLabel.loadView()
//        secondAnswerLabel.delegate = self
//        self.scrollView.addSubview(secondAnswerLabel)
//        
//        answerY = secondAnswerLabel.frame.origin.y + firstAnswerLabel.frame.height + answerTop
//        let thirdAnswerLabel = CustomAnswerLabel(frame: CGRectMake(answerLeading, answerY, UIApplication.sharedApplication().keyWindow!.frame.width - (answerLeading * 2), minimumAnswerHeight))
//        thirdAnswerLabel.loadView()
//        thirdAnswerLabel.delegate = self
//        self.scrollView.addSubview(thirdAnswerLabel)
        
    }
    
    override func viewDidLayoutSubviews() {
        print(questionLabel.frame.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func answerTapped(correct: Bool) {
        
        print(correct)
        print(questionLabel.frame.height)
        
    }

}
