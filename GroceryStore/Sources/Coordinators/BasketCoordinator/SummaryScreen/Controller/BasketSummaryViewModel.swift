//
//  BasketSummaryViewModel.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import Foundation

class BasketSummaryViewModel {
    
    // MARK: - Properties
    
    private var currency: Currency?
    private var dataProvider: ProductsProvidable
    private let basketStorage: BasketStorable
    
    private var productsViewModels: [ProductViewModel]?
    
    public var onError: ((String) -> Void)?
    public var onFinish: (([ProductViewModel]) -> Void)?
    public var onBasketUpdate: ((Price?) -> Void)?
    public var dismissSummary: (() -> Void)?
    public var showCurrenciec: (() -> Void)?
    
    private var zeroTotalPrice: Price {
        let amount = Decimal(floatLiteral: 0.0)
        let priceCurrency = currency?.currency ?? "usd"
        return Price(amount: amount, currency: priceCurrency)
    }
    
    // MARK: - Initilizer
    
    init(dataProvider: ProductsProvidable, storage: BasketStorable) {
        self.dataProvider = dataProvider
        self.basketStorage = storage
        
        setupViewModels()
    }
    
    // MARK: - Public methods
    
    public func fetchProducts() {
        guard let products = productsViewModels else {
            onError?("We couldn't find any products.")
            return
        }
        
        onFinish?(products)
    }
    
    public func fetchBasket() {
        checkBasketPrice()
    }
    
    public func onCurrencyChange(currency: Currency) {
        self.currency = currency
        checkBasketPrice(with: currency)
    }
    
    // MARK: - Private methods
    
    private func setupViewModels() {
        guard let products = dataProvider.loadProducts() else {
            productsViewModels = nil
            return
        }
        
        var viewModels: [ProductViewModel] = []
        for product in products {
            
            let storageItem: StorableItem? = basketStorage.element(for: product.id)
            guard let basketCounter = storageItem?.counter, basketCounter > 0 else {
                continue
            }
            
            let viewModel = ProductViewModel(model: product)
            viewModel.basketCounter = basketCounter
            
            viewModel.basketCounterChanged = { [weak self] product, counter in
                self?.basketChangedHandler(with: product, counter: counter)
            }
            
            viewModels.append(viewModel)
        }
        
        productsViewModels = viewModels
    }
    
    private func basketChangedHandler(with product: Product, counter: Int) {
        basketStorage.add(StorableItem(id: product.id, counter: counter))
        
        if counter == 0, let index = productsViewModels?.firstIndex(where: { $0.id == product.id }) {
            productsViewModels?.remove(at: index)
        }
        
        onFinish?(productsViewModels ?? [])
        
        checkBasketPrice(with: currency)
    }
    
    private func checkBasketPrice(with converter: Currency? = nil) {
        
        guard let productsViewModels = productsViewModels,
            !productsViewModels.isEmpty,
            var currency = productsViewModels.first?.price.currency else {
                onBasketUpdate?(zeroTotalPrice)
                return
        }
        
        var totalPrice: Double = 0.0
        var elements: Int = 0
        for viewModel in productsViewModels {
            let price = viewModel.summaryPrice.decimalNumber.doubleValue
            elements += viewModel.basketCounter
            totalPrice += price
        }
        
        if let converter = converter {
            totalPrice *= converter.decimalNumber.doubleValue
            currency = converter.currency
        }
        
        onBasketUpdate?(Price(amount: Decimal(floatLiteral: totalPrice), currency: currency))
    }
}
