//
//  DirectoryViewController.swift
//  iXplore
//
//  Created by Alexander Ge on 7/20/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class DirectoryViewController: UIViewController {

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

    

}
















