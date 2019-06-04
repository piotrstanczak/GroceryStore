//
//  ProductsProvider.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import Foundation

protocol ProductsProvidable: DataProvidable {
    func loadProducts() -> [Product]?
}

struct ProductsProvider: ProductsProvidable {
    
    private let loader: DataLoadable
    
    init(loader: DataLoadable) {
        self.loader = loader
    }
    
    public func loadProducts() -> [Product]? {
        let products: Products? = fetchIfPossible(try loader.load())
        return products?.products
    }
}
