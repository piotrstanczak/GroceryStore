//
//  BasketStorage.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import Foundation

protocol BasketStorable {
    func add<T: StorableType>(_ element: T)
    func remove<T: StorableType>(_ element: T)
    func element<T: StorableType>(for id: String) -> T?
}

class BasketStorage: BasketStorable {
    
    // MARK: - Properties
    
    private let storageKey: String
    private let userDefaults: UserDefaults
    private var elements: [String: Int]
    
    // MARK: - Initializer
    
    init(with userDefaults: UserDefaults, storageKey: String) {
        self.userDefaults = userDefaults
        self.storageKey = storageKey
        self.elements = userDefaults.object(forKey: storageKey) as? [String: Int] ?? [:]
    }
    
    // MARK: - Public methods
    
    public func add<T: StorableType>(_ element: T) {
        self.elements[element.id] = element.counter
        self.userDefaults.set(self.elements, forKey: storageKey)
    }
    
    public func remove<T: StorableType>(_ element: T) {
        self.elements.removeValue(forKey: element.id)
        self.userDefaults.set(self.elements, forKey: storageKey)
    }
    
    public func element<T: StorableType>(for id: String) -> T? {
        guard let elementValue = elements[id] else {
            return nil
        }
        
        return StorableItem(id: id, counter: elementValue) as? T
    }
}

