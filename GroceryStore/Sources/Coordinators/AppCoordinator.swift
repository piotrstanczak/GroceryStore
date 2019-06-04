//
//  AppCoordinator.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 31/05/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator<UIWindow, CoordinatorFactory, Empty> {
    
    override func start() {
        let splashCoordinator = factory.coordinator(for: SplashCoordinator.self, with: navigator)
        
        navigate(to: splashCoordinator) { [weak self] _ in
            self?.showGroceryListViewController()
        }
        
        splashCoordinator.start()
    }
    
    private func showGroceryListViewController() {
        let listViewCoordinator = factory.coordinator(for: ProductsCoordinator.self, with: navigator)
        navigate(to: listViewCoordinator) {}        
        listViewCoordinator.start()
    }
}

