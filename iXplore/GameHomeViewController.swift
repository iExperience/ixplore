//
//  GameHomeViewController.swift
//  iXplore
//
//  Created by Brian Ge on 7/18/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class GameHomeViewController: UIViewController, UINavigationControllerDelegate {

    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.delegate = self
        
        let triviaButton = UIButton(frame: CGRectMake(0,0,150,150))
        triviaButton.center = CGPointMake(appDelegate.window!.center.x, appDelegate.window!.frame.height / 3)
        triviaButton.backgroundColor = UIColor(netHex: 0xe32181)
        triviaButton.layer.cornerRadius = triviaButton.frame.height / 2
        triviaButton.addTarget(self, action: #selector(triviaButtonTapped(_:)), forControlEvents: .TouchUpInside)
        triviaButton.setTitle("iXpert", forState: .Normal)
        triviaButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.view.addSubview(triviaButton)
        
        let challengeButton = UIButton(frame: CGRectMake(0,0,150,150))
        challengeButton.center = CGPointMake(appDelegate.window!.center.x, appDelegate.window!.frame.height * 2 / 3)
        challengeButton.backgroundColor = UIColor(netHex: 0xe32181)
        challengeButton.layer.cornerRadius = challengeButton.frame.height / 2
        challengeButton.addTarget(self, action: #selector(challengeButtonTapped(_:)), forControlEvents: .TouchUpInside)
        challengeButton.setTitle("iXtreme", forState: .Normal)
        challengeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.view.addSubview(challengeButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let _ = fromVC as? QuestionViewController {
            if let _ = toVC as? QuestionViewController{
                let flipPresentAnimationController = FlipPresentAnimationController()
                flipPresentAnimationController.backgroundColor = UIColor(netHex: 0x52bdbf).colorWithAlphaComponent(0.2)
                return flipPresentAnimationController
            }
        }
        return nil
    }
    
    @IBAction func menuButtonTapped(sender: UIButton) {
        self.slideMenuController()?.openLeft()
    }
    
    func triviaButtonTapped(sender: UIButton) {
//        for _ in 0...2 {
//            let qvc = QuestionViewController(nibName: "QuestionViewController", bundle: nil)
//            qvc.question = Question(question: "Yes? DO you ahve a quesiton? Because I don't and I'm really tired and don't want to think of a good question.", answers: ["yes asdfkjhb aslfkha asdfjlkj lkjasdflkjaslkdjfnalkjs lakjsdlka alksjdblkjbsdlkfjansld aldkj lkjkj kj kj  falksj asdlfkj asdflkj asdfklj  fdskj asdlkj lkasjd endinghappensnow", "no i don't like shirmp very much because it's kind of gorss and I hate gorss things because they are gross like you", "yes"], correctAnswer: 2, explanation: "yes should be the correct answer becuase yes is yes while no is no and also yes is cooler but then again amybe no should be right but if it was then everything would be turned upside down so no can't be right because right isn't left but left is right so right is also left as well which makes even less sense so what is really right? Because if yes is right and right is left then yes is left and no is right...")
//            viewControllers.append(qvc)
//            
//        }
        let qvc1 = QuestionViewController(nibName: "QuestionViewController", bundle: nil)
        qvc1.question = Question(question: "Do we really need a designer to redo all of our color schemes and fix all of the icons in this app?", answers: ["No", "Kind of", "Is that really a question...?"], correctAnswer: 2, explanation: "We actually have a wonderful piece of artwork courtesy of Alex to demonstrate the peak of our artistic talents! Aaron will love this one.")
        let qvc2 = QuestionViewController(nibName: "QuestionViewController", bundle: nil)
        qvc2.question = Question(question: "Do you spell the word 'remarkbly' with or without a 'b'?", answers: ["With", "Without"], correctAnswer: 1, explanation: "While the average person might think remarkbly is spelled with a 'b', our brilliant boss Rafi insists that it does not contain a 'b'. Therefore the correct answer is without.")
        let tvc = ThanksViewController(nibName: "ThanksViewController", bundle: nil)
        self.navigationController?.setViewControllers([self, tvc, qvc2, qvc1], animated: true)
    }
    
    func challengeButtonTapped(sender: UIButton) {
        let wcvc = WeeklyChallengeViewController(nibName: "WeeklyChallengeViewController", bundle: nil)
        wcvc.challengeDescription = "Take a photo with 3 friends and a fork on top of table mountain!"
        self.navigationController?.pushViewController(wcvc, animated: true)
    }
    
}
