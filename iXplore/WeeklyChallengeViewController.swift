//
//  WeeklyChallengeViewController.swift
//  iXplore
//
//  Created by Brian Ge on 7/20/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class WeeklyChallengeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var challengeDescription: String!
    var challengeLabel: UILabel!
    var uploadPhotoButton: UIButton!
    var submitButton: UIButton!
    var imageView: UIImageView!
    
    var challengeLeading: CGFloat = 20
    var challengeTop: CGFloat = 25
    var uploadTop: CGFloat = 30
    var submitTop: CGFloat = 20
    
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        challengeLabel = UILabel()
        challengeLabel.numberOfLines = 0
        challengeLabel.textAlignment = .Center
        challengeLabel.frame.size.width = (appDelegate.window?.frame.width)! - (challengeLeading * 2)
        challengeLabel.font = UIFont(name: "Lato-Regular", size: 18)
        challengeLabel.text = challengeDescription
        challengeLabel.sizeToFit()
        challengeLabel.center.x = (appDelegate.window?.center.x)!
        challengeLabel.frame.origin.y = challengeTop
        self.scrollView.addSubview(challengeLabel)
        
        uploadPhotoButton = UIButton()
        uploadPhotoButton.frame.origin.y = challengeLabel.frame.origin.y + challengeLabel.frame.height + uploadTop
        uploadPhotoButton.titleLabel!.font = UIFont(name: "Lato-Regular", size: 18)
        uploadPhotoButton.titleLabel?.textAlignment = .Center
        uploadPhotoButton.setTitle("Upload Photo", forState: .Normal)
        uploadPhotoButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        uploadPhotoButton.backgroundColor = UIColor(netHex: 0xe32181)
        uploadPhotoButton.sizeToFit()
        uploadPhotoButton.frame.size.height += 15
        uploadPhotoButton.frame.size.width += 20
        uploadPhotoButton.center.x = (appDelegate.window?.center.x)!
        uploadPhotoButton.addTarget(self, action: #selector(uploadPhoto), forControlEvents: .TouchUpInside)
        self.scrollView.addSubview(uploadPhotoButton)
        
        imageView = UIImageView(frame: CGRectMake(0, 0, 0, 0))
        self.scrollView.addSubview(imageView)
        
        submitButton = UIButton()
        submitButton.titleLabel!.font = UIFont(name: "Lato-Regular", size: 18)
        submitButton.titleLabel?.textAlignment = .Center
        submitButton.setTitle("submit Photo", forState: .Normal)
        submitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        submitButton.backgroundColor = UIColor(netHex: 0xe32181)
        submitButton.sizeToFit()
        submitButton.frame.size.height += 15
        submitButton.frame.size.width += 20
        submitButton.center.x = (appDelegate.window?.center.x)!
        submitButton.addTarget(self, action: #selector(submitPhoto), forControlEvents: .TouchUpInside)
        submitButton.hidden = true
        self.scrollView.addSubview(submitButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func uploadPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
//        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func submitPhoto() {
        print("submitted")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        let aspectRatio = image.size.height / image.size.width
        imageView.image = image
        imageView.frame.size.width = (appDelegate.window?.frame.width)! - 100
        imageView.frame.size.height = imageView.frame.size.width * aspectRatio
        imageView.contentMode = .ScaleAspectFit
        print(uploadPhotoButton.frame.origin.y)
        print(scrollView.frame.origin.y)
        imageView.frame.origin.y = self.uploadPhotoButton.frame.origin.y + self.uploadPhotoButton.frame.height + 20
        imageView.center.x = self.view.center.x
        submitButton.frame.origin.y = imageView.frame.origin.y + imageView.frame.height + 20
        submitButton.hidden = false
        scrollView.contentSize.height = submitButton.frame.origin.y + submitButton.frame.height + 20
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

}
