//
//  BasketCoordinator.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

class BasketCoordinator: Coordinator<UINavigationController, CoordinatorFactory & ViewControllerFactory, Empty> {
    
    // MARK: - Properties
    
    private var transitionHandler: TransitionHandler?
    
    override func start() {
        showSummaryView()
    }
    
    // MARK: - Coordinator methods
    
    private func showSummaryView() {
        guard let currentViewController = navigator.viewControllers.last else {
            return
        }
        
        let summaryViewController = factory.viewController(for: BasketSummaryViewController.self)
        let navigationController = UINavigationController(rootViewController: summaryViewController)
        transitionHandler = TransitionHandler(from: currentViewController, to: navigationController)
        navigationController.transitioningDelegate = transitionHandler
        navigationController.modalPresentationStyle = .custom
        currentViewController.present(navigationController, animated: true, completion: nil)
        
        summaryViewController.viewModel?.dismissSummary = { [weak self] in
            self?.dismissSummaryView()
        }
        
        summaryViewController.viewModel?.showCurrenciec = { [weak self] in
            self?.showCurrenciecView()
        }
    }
    
    private func showCurrenciecView() {
        guard let currentViewController = navigator.presentedViewController as? UINavigationController else {
            return
        }
        
        let viewController = factory.viewController(for: CurrencyListViewController.self)
        
        viewController.viewModel?.onSelectCurrency = { [weak self] currency in
            currentViewController.popViewController(animated: true)
            self?.onSelectCurrency(currency: currency)
        }
        
        currentViewController.show(viewController, sender: currentViewController)
    }
    
    // MARK: Action handlers
    
    private func onSelectCurrency(currency: Currency) {
        guard let navigationController = navigator.presentedViewController as? UINavigationController,
            let summaryViewController = navigationController.viewControllers.last as? BasketSummaryViewController else {
            return
        }
        
        summaryViewController.viewModel?.onCurrencyChange(currency: currency)
    }
    
    private func dismissSummaryView() {
        navigator.viewControllers.last?.dismiss(animated: true, completion: {
            self.onCompleted?(Empty())
        })
    }

}
