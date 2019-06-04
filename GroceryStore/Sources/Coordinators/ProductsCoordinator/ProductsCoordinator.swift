//
//  ProductsCoordinator.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

class ProductsCoordinator: Coordinator<UIWindow, CoordinatorFactory & ViewControllerFactory, Empty> {
    
    override func start() {
        showProductListView()
    }
    
    // MARK: Private methods
    
    private func showProductListView() {
        let viewController = factory.viewController(for: ProductsListViewController.self)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.viewModel?.showBasket = { [weak self] in
            self?.showBasketView()
        }
        
        navigator.rootViewController = navigationController
        UIView.transition(with: navigator,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
    
    private func showBasketView() {
        guard let navigation = navigator.rootViewController as? UINavigationController else {
            return
        }
        
        let basketCoordinator = factory.coordinator(for: BasketCoordinator.self, with: navigation)
        
        navigate(to: basketCoordinator) { [weak self] in
            self?.onBasketClosed()
        }
        
        basketCoordinator.start()
    }
    
    // MARK: Action handlers
    
    private func onBasketClosed() {
        guard let navigationController = navigator.rootViewController as? UINavigationController,
            let productListViewController = navigationController.viewControllers.last as? ProductsListViewController else {
            return
        }
        
        productListViewController.viewModel?.fetchProducts()
        productListViewController.viewModel?.fetchBasket()
    }
}

