//
//  QuestionController.swift
//  iXplore
//
//  Created by Brian Ge on 7/19/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import Foundation

struct Question {
    
    var question: String
    var answers: [String]
    var correctAnswer: Int
    
}

class QuestionController {
    
    var questions: [Question] = []
    
    class var sharedInstance: QuestionController {
        
        struct Static {
            static var instance: QuestionController?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token)    {
            Static.instance = QuestionController()
        }
        return Static.instance!
    }
    
    func loadQuestions() {
        let question = Question(question: "Is it raining?", answers: ["No", "Yes", "Maybe"], correctAnswer: 2)
        questions.append(question)
    }
    
}