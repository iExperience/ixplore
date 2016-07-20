//
//  GameHomeViewController.swift
//  iXplore
//
//  Created by Brian Ge on 7/18/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class GameHomeViewController: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let _ = fromVC as? QuestionViewController {
            if let _ = toVC as? QuestionViewController{
                return FlipPresentAnimationController()
            }
        }
        return nil
    }
    
    @IBAction func menuButtonTapped(sender: UIButton) {
        self.slideMenuController()?.openLeft()
    }

    @IBAction func triviaButtonTapped(sender: UIButton) {
        var viewControllers: [UIViewController] = [self]
        for _ in 0...2 {
            let qvc = QuestionViewController(nibName: "QuestionViewController", bundle: nil)
            qvc.question = Question(question: "Yes? DO you ahve a quesiton? Because I don't and I'm really tired and don't want to think of a good question.", answers: ["yes asdfkjhb aslfkha asdfjlkj lkjasdflkjaslkdjfnalkjs lakjsdlka alksjdblkjbsdlkfjansld aldkj lkjkj kj kj  falksj asdlfkj asdflkj asdfklj  fdskj asdlkj lkasjd endinghappensnow", "no i don't like shirmp very much because it's kind of gorss and I hate gorss things because they are gross like you", "yes"], correctAnswer: 2, explanation: "yes should be the correct answer becuase yes is yes while no is no and also yes is cooler but then again amybe no should be right but if it was then everything would be turned upside down so no can't be right because right isn't left but left is right so right is also left as well which makes even less sense so what is really right? Because if yes is right and right is left then yes is left and no is right...")
            viewControllers.append(qvc)
        
        }
        self.navigationController?.setViewControllers(viewControllers, animated: true)
        
    }
    
    @IBAction func challengeButtonTapped(sender: UIButton) {
        let wcvc = WeeklyChallengeViewController(nibName: "WeeklyChallengeViewController", bundle: nil)
        wcvc.challengeDescription = "Take a photo with 3 friends and a fork on top of table mountain!"
        self.navigationController?.pushViewController(wcvc, animated: true)
    }
    
}
