//
//  QuestionViewController.swift
//  iXplore
//
//  Created by Brian Ge on 7/18/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, CustomAnswerViewDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var question: Question!
    var answerViews: [CustomAnswerView] = []
    
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let questionTop: CGFloat = 30
    let questionImageHeight: CGFloat = 100
    let answerLeading: CGFloat = 20
    let answerTop: CGFloat = 20
    let minimumAnswerHeight: CGFloat = 70
    
    var timeCount = 10
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let backgroundView = UIView(frame: appDelegate.window!.frame)
//        backgroundView.backgroundColor = UIColor(netHex: 0x52bdbf).colorWithAlphaComponent(0.2)
//        self.view.addSubview(backgroundView)
//        self.view.sendSubviewToBack(backgroundView)

        // Do any additional setup after loading the view.
        questionLabel.text = question.question
        questionLabel.frame.size.height = questionLabel.heightForLabel(questionLabel.text!, font: UIFont(name: "Lato-Regular", size: 20)!, width: appDelegate.window!.frame.width - questionImageHeight - 60)
        
        var answerY = max(questionLabel.frame.height, questionImageHeight) + answerTop + questionTop
        
        for i in 0..<question.answers.count {
            
            let answerView = CustomAnswerView(frame: CGRectMake(answerLeading, answerY, appDelegate.window!.frame.width - (answerLeading * 2), minimumAnswerHeight))
            answerView.answer = question.answers[i]
            answerView.loadView()
            answerView.delegate = self
            answerView.correct = (i == question.correctAnswer)
            self.scrollView.addSubview(answerView)
            answerY += answerView.frame.height + answerTop
            
            answerViews.append(answerView)
            
            if i == question.answers.count - 1 {
                scrollView.contentSize.height = answerView.frame.origin.y + answerView.frame.height + 20
            }
            
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showCorrectAnswer(correct: Bool, timeUp: Bool, answerView: CustomAnswerView?) {
        
        questionLabel.removeFromSuperview()
        questionImageView.removeFromSuperview()
        timeLabel.removeFromSuperview()
        
        let resultLabel = UILabel()
        resultLabel.font = UIFont(name: "Lato-Bold", size: 36)
        if timeUp {
            resultLabel.text = "Time's Up!"
            resultLabel.textColor = UIColor(netHex: 0xf16577)
        }
        else if correct {
            resultLabel.text = "You got it!"
            resultLabel.textColor = UIColor(netHex: 0x4bbe9c)
        }
        else {
            resultLabel.text = "Nice try!"
            resultLabel.textColor = UIColor(netHex: 0xf16577)
        }
        resultLabel.sizeToFit()
        resultLabel.frame.origin.y = 30
        resultLabel.center.x = self.view.center.x
        resultLabel.alpha = 0
        self.scrollView.addSubview(resultLabel)
        
        let correctLabel = UILabel()
        correctLabel.font = UIFont(name: "Lato-Heavy", size: 24)
        correctLabel.text = "Correct Answer:"
        correctLabel.textColor = UIColor(netHex: 0x4bbe9c)
        correctLabel.sizeToFit()
        correctLabel.frame.origin.y = resultLabel.frame.origin.y + resultLabel.frame.height + 30
        correctLabel.center.x = self.view.center.x
        correctLabel.alpha = 0
        self.scrollView.addSubview(correctLabel)
        
        let explanationLabel = UILabel()
        explanationLabel.numberOfLines = 0
        explanationLabel.font = UIFont(name: "Lato-Regular", size: 18)
        explanationLabel.text = question.explanation
        explanationLabel.frame.size.width = appDelegate.window!.frame.width - (answerLeading * 2)
        explanationLabel.sizeToFit()
        explanationLabel.frame.size.width = (appDelegate.window?.frame.width)! - (answerLeading * 2)
        explanationLabel.center.x = self.view.center.x
        explanationLabel.alpha = 0
        self.scrollView.addSubview(explanationLabel)
        
        let nextQuestionButton = UIButton()
        nextQuestionButton.setTitle("Next Question", forState: .Normal)
        nextQuestionButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: 18)
        nextQuestionButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        nextQuestionButton.backgroundColor = UIColor(netHex: 0xe32181)
        nextQuestionButton.layer.cornerRadius = 5
        nextQuestionButton.sizeToFit()
        nextQuestionButton.frame.size.width += 20
        nextQuestionButton.frame.size.height += 15
        nextQuestionButton.titleLabel?.textAlignment = .Center
        nextQuestionButton.center.x = self.view.center.x
        nextQuestionButton.alpha = 0
        nextQuestionButton.addTarget(self, action: #selector(self.nextQuestion), forControlEvents: .TouchUpInside)
        self.scrollView.addSubview(nextQuestionButton)
        
        timer.invalidate()
        
        for subview in scrollView.subviews {
            if let answer = subview as? CustomAnswerView {
                answer.userInteractionEnabled = false
            }
        }
        
        for answer in self.answerViews {
            
            var answerWrong: Bool = false
            if let answerView = answerView {
                answerWrong = !answerView.correct
            }
            
            if answer.correct! {
                UIView.animateWithDuration(0.5, animations: {
                    answer.backgroundColor = UIColor(netHex: 0x4bbe9c).colorWithAlphaComponent(0.2)
                    //                        answer.layer.borderColor = UIColor(netHex: 0x4bbe9c).CGColor
                    if answerWrong {
                        answerView?.backgroundColor = UIColor(netHex: 0xf16577).colorWithAlphaComponent(0.2)
                        //                            answerView?.layer.borderColor = UIColor(netHex: 0xf16577).CGColor
                    }
                    }, completion: {(true) in
                        if answerWrong {
                            UIView.animateWithDuration(0.2, animations: {
                                answerView?.alpha = 0
                                }, completion: {(true) in
                                    answerView?.removeFromSuperview()
                            })
                        }
                        UIView.animateWithDuration(0.5, animations: {
                            resultLabel.alpha = 1
                            correctLabel.alpha = 1
                            answer.frame.origin.y = correctLabel.frame.origin.y + correctLabel.frame.height + 10
                            }, completion: {(true) in
                                explanationLabel.frame.origin.y = answer.frame.origin.y + answer.frame.height + 20
                                nextQuestionButton.frame.origin.y = explanationLabel.frame.origin.y + explanationLabel.frame.height + 20
                                self.scrollView.contentSize.height = nextQuestionButton.frame.origin.y + nextQuestionButton.frame.height + 20
                                UIView.animateWithDuration(0.2, animations: {
                                    explanationLabel.alpha = 1
                                    nextQuestionButton.alpha = 1
                                })
                        })
                })
            }
            else if answer != answerView {
                answer.removeFromSuperview()
            }
            
        }
        
    }
    
    func answerTapped(sender: CustomAnswerView, correct: Bool) {
        
        showCorrectAnswer(correct, timeUp: false, answerView: sender)
        
    }
    
    func update() {
        
        timeCount -= 1
        
        if timeCount > 0 {
            timeLabel.text = String(timeCount)
            if timeCount == 5 {
                timeLabel.textColor = UIColor(netHex: 0xf16577)
            }
        }
        else {
            print("hey")
            showCorrectAnswer(false, timeUp: true, answerView: nil)
        }
    }

    func nextQuestion() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
