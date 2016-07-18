//
//  GameHomeViewController.swift
//  iXplore
//
//  Created by Brian Ge on 7/18/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class GameHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonTapped(sender: UIButton) {
        self.slideMenuController()?.openLeft()
    }

    @IBAction func triviaButtonTapped(sender: UIButton) {
    }
    
    @IBAction func challengeButtonTapped(sender: UIButton) {
    }
    
}
