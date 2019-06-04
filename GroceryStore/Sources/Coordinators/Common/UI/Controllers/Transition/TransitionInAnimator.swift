//
//  TransitionInAnimator.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 31/05/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

class TransitionInAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration = 0.3
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        let startPoint = CGPoint(x: containerView.frame.midX, y: containerView.frame.size.height)
        let finalPoint = toViewController.view.center
        
        toViewController.view.center = startPoint
        toViewController.view.layer.shadowColor = UIColor.black.cgColor
        toViewController.view.layer.shadowOffset = CGSize(width: 5.0, height: 4.0)
        toViewController.view.layer.shadowOpacity = 0.2
        
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: duration, animations: {
            toViewController.view.center = finalPoint
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
}


