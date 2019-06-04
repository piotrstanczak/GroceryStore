//
//  TransitionPresentationController.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 31/05/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

class TransitionPresentationController: UIPresentationController {
    
    // MARK: - Properties
    private let scaleValue: CGFloat = 0.8
    private var blurView: UIView?
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        setupVisualEffectView()
    }
    
    private func setupVisualEffectView() {
        let blurView = UIView(frame: presentingViewController.view.bounds)
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark)) as UIVisualEffectView
        visualEffectView.frame = blurView.bounds
        visualEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurView.addSubview(visualEffectView)
        
        self.blurView = blurView
    }
    
    override func presentationTransitionWillBegin() {
        guard let blurView = blurView else {
            return
        }
        
        let containerView = self.containerView
        let presentedViewController = self.presentedViewController
        
        blurView.frame = containerView!.bounds
        blurView.alpha = 0.0
        
        containerView!.insertSubview(blurView, at: 0)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            blurView.alpha = 1.0
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        guard let blurView = blurView else {
            return
        }
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            blurView.alpha = 0.0
        }, completion: nil)
    }
    
    override func containerViewWillLayoutSubviews() {
        guard let blurView = blurView else {
            return
        }
        
        blurView.frame = containerView!.bounds
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width * scaleValue, height: parentSize.height * scaleValue)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect.zero
        let containerBounds = containerView!.bounds
        
        let contentContainer = presentedViewController
        
        presentedViewFrame.size = size(forChildContentContainer: contentContainer, withParentContainerSize: containerBounds.size)
        presentedViewFrame.origin.x = (containerBounds.width - (containerBounds.width * scaleValue)) / 2
        presentedViewFrame.origin.y = (containerBounds.height - (containerBounds.height * scaleValue)) / 2
        
        return presentedViewFrame
    }
    
}
