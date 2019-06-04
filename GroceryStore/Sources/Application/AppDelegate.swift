//
//  AppDelegate.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 31/05/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let appDependencies = AppDependencies()
    private var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {        
        setupRootView()
        return true
    }
    
    private func setupRootView() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
        
        self.appCoordinator = appDependencies.coordinator(for: AppCoordinator.self, with: window)
        self.appCoordinator.start()
        
        self.window = window
    }

}

