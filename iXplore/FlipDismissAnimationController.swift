//
//  FlipDismissAnimationController.swift
//  iXplore
//
//  Created by Brian Ge on 7/19/16.
//  Copyright © 2016 iXperience. All rights reserved.
//

import UIKit

class FlipDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let containerView = transitionContext.containerView(),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                return
        }
        
        let backgroundView = UIView(frame: containerView.frame)
        backgroundView.backgroundColor = UIColor.whiteColor()
        let overlayView = UIView(frame: containerView.frame)
        overlayView.backgroundColor = UIColor(netHex: 0x4bbe9c).colorWithAlphaComponent(0.2)
        backgroundView.addSubview(overlayView)
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.addSubview(backgroundView)
        appDelegate.window?.sendSubviewToBack(backgroundView)
        
        toVC.view.frame = UIScreen.mainScreen().bounds
        
        containerView.addSubview(toVC.view)
        
        AnimationHelper.perspectiveTransformForContainerView(containerView)
        toVC.view.layer.transform = AnimationHelper.yRotation(-M_PI_2)
        
        let duration = transitionDuration(transitionContext)
        
        UIView.animateKeyframesWithDuration(
            duration,
            delay: 0,
            options: .CalculationModeCubic,
            animations: {
                
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1/3, animations: {
                    fromVC.view.layer.transform = AnimationHelper.yRotation(M_PI_2)
                })
                
                UIView.addKeyframeWithRelativeStartTime(1/3, relativeDuration: 2/3, animations: {
                    toVC.view.layer.transform = AnimationHelper.yRotation(0.0)
                })
                
            },
            completion: { _ in
                fromVC.view.layer.transform = AnimationHelper.yRotation(0.0)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
        
    }
    
}
