//
//  MenuViewController.swift
//  iXplore
//
//  Created by Brian Ge on 7/4/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func calendarButtonTapped(sender: UIButton) {
        let cvc = CalendarViewController(nibName: "CalendarViewController", bundle: nil)
        self.navigationController?.pushViewController(cvc, animated: true)
    }

    @IBAction func newsletterButtonTapped(sender: UIButton) {
        let nvc = NewsViewController(nibName: "NewsViewController", bundle: nil)
        self.navigationController?.pushViewController(nvc, animated: true)
    }
    
    @IBAction func supportButtonTapped(sender: UIButton) {
        let svc = SupportViewController(nibName: "SupportViewController", bundle: nil)
        self.navigationController?.pushViewController(svc, animated: true)
    }

}
