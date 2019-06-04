//
//  SplashCoordinator.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 31/05/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

class SplashCoordinator: Coordinator<UIWindow, CoordinatorFactory & ViewControllerFactory, Empty> {
    
    override func start() {
        let viewController = factory.viewController(for: SplashViewController.self, viewModel: nil)
        
        navigator.rootViewController = viewController
        navigator.makeKeyAndVisible()
        
        viewController.viewModel?.completed = { [weak self] in
            self?.onCompleted?(Empty())
        }
    }
}
