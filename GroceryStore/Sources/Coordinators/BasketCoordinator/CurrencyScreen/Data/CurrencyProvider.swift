//
//  CurrencyProvider.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 03/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import Foundation

typealias FinishCallback = (Result<Currencies, NetworkingError>) -> Void

protocol CurrencyProvidable {
    func loadProducts(onFinish: @escaping FinishCallback)
}

struct CurrencyProvider: CurrencyProvidable {
    
    private var request: RequestExecutable
    
    init(request: RequestExecutable) {
        self.request = request
    }
    
    func loadProducts(onFinish: @escaping FinishCallback) {
        self.request.load(callback: onFinish)
    }
}

