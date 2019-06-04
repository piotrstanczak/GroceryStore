//
//  TransitionHandler.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 31/05/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

class TransitionHandler: NSObject, UIViewControllerTransitioningDelegate {
    
    init(from presented: UIViewController, to presenting: UIViewController) {
        super.init()
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return TransitionPresentationController(presentedViewController: presented, presenting: source)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionInAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionOutAnimator()
    }
}
