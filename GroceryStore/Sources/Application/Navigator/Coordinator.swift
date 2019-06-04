//
//  Coordinator.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 31/05/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

public typealias Empty = Void

protocol Completable {
    associatedtype Completion
    var onCompleted: ((Completion) -> ())? { get set }
}

open class Coordinator<NavigatorType, FactoryType, ResultType>: Completable {
    
    public typealias Navigator = NavigatorType
    public typealias Factory = FactoryType
    public typealias Completion = ResultType
    
    // MARK: - Properties
    
    private let identifier = UUID()
    private var children = [UUID: Any]()
    
    public let navigator: Navigator
    public let factory: Factory
        
    public var onCompleted: ((ResultType) -> ())?
    
    
    // MARK: - Initializer
    
    init(navigator: Navigator, factory: Factory) {
        self.navigator = navigator
        self.factory = factory
    }
    
    // MARK: - Private methods
    
    private func store<N, F, R>(coordinator: Coordinator<N, F, R>) {
        children[coordinator.identifier] = coordinator
    }
    
    private func free<N, F, R>(coordinator: Coordinator<N, F, R>) {
        children[coordinator.identifier] = nil
    }
    
    // MARK: - Public methods
    
    /// Navigate to new coordinator
    ///
    /// - Parameters:
    ///   - coordinator: new screen coordinator
    ///   - completion: completion callback
    public func navigate<N, F, R>(to coordinator: Coordinator<N, F, R>, with completion: @escaping (R) -> ()) {
        store(coordinator: coordinator)
        coordinator.onCompleted = completion        
    }
    
    /// Coordinator start method
    public func start() {
        fatalError("This method should be implemented!")
    }
}

