//
//  TransitionOutAnimator.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 31/05/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

class TransitionOutAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration = 0.3
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        
        let containerView = transitionContext.containerView
        let finalPoint = CGPoint(x: containerView.frame.midX, y: containerView.frame.size.height)
        
        UIView.animate(withDuration: duration, animations: {
            fromViewController.view.center = finalPoint
        }) { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
