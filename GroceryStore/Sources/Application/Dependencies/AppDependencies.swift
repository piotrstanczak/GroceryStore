//
//  AppDependencies.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 31/05/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

/// App dependencies that later will be injected into proper VM
class AppDependencies {
    fileprivate lazy var storage = BasketStorage(with: UserDefaults.standard, storageKey: "basket")
    fileprivate lazy var currenciesRequest = RequestExecutor(urlSession: .shared, baseUrl: "http://www.apilayer.net/api/live?access_key=bd4552ddce2428ea763b6616f89f8a38&format=1")
    fileprivate lazy var currencyProvider = CurrencyProvider(request: currenciesRequest)
    fileprivate lazy var productsProvider = ProductsProvider(loader: DataLoader(fileName: "Products", bundle: Bundle(for: type(of: self))))
}

extension AppDependencies: CoordinatorFactory {
    
    func coordinator<N, F, R, C: Coordinator<N, F, R>>(for type: C.Type, with navigator: N) -> C {
        switch type {
            
        case is AppCoordinator.Type:
            return AppCoordinator(navigator: navigator as! UIWindow, factory: self) as! C
            
        case is SplashCoordinator.Type:
            return SplashCoordinator(navigator: navigator as! UIWindow, factory: self) as! C
            
        case is ProductsCoordinator.Type:
            return ProductsCoordinator(navigator: navigator as! UIWindow, factory: self) as! C
            
        case is BasketCoordinator.Type:
            return BasketCoordinator(navigator: navigator as! UINavigationController, factory: self) as! C
            
        default:
            fatalError("Coordinator not implemented.")
        }
    }
}

extension ViewControllerFactory where Self: AppDependencies {

    func viewController<T: ViewModelInjectable & ViewConfigurable>(for type: T.Type) -> T {
        return viewController(for: type, viewModel: nil)
    }
    
    func viewController<T: ViewModelInjectable & ViewConfigurable, S>(for type: T.Type, viewModel: S? = nil) -> T where S == T.ViewModelType {
        switch type {
        case is SplashViewController.Type:
            let splashViewController = SplashViewController()
            splashViewController.viewModel = SplashViewModel()
            splashViewController.config = SplashViewConfig()
            return splashViewController as! T

        case is ProductsListViewController.Type:            
            let viewController = ProductsListViewController()
            viewController.viewModel = ProductsListViewModel(dataProvider: productsProvider, storage: storage)
            viewController.config = ProductsListViewConfig()
            return viewController as! T

        case is BasketSummaryViewController.Type:
            let viewController = BasketSummaryViewController()
            viewController.viewModel = BasketSummaryViewModel(dataProvider: productsProvider, storage: storage)
            viewController.config = BasketSummaryViewConfig()
            return viewController as! T
            
        case is CurrencyListViewController.Type:
            let viewController = CurrencyListViewController()
            viewController.viewModel = CurrencyListViewModel(dataProvider: currencyProvider)
            viewController.config = CurrencyListViewConfig()
            return viewController as! T
            
        default:
            fatalError("It should be implemented")
        }
    }
}

extension AppDependencies: ViewControllerFactory {}
