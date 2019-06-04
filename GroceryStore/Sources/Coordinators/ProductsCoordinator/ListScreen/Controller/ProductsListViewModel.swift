//
//  ProductsListViewModel.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import Foundation

class ProductsListViewModel {
    
    // MARK: - Properties
    
    private var dataProvider: ProductsProvidable
    private let basketStorage: BasketStorable
    
    private var productsViewModels: [ProductViewModel]?
    
    public var onError: ((String) -> Void)?
    public var onFinish: (([ProductViewModel]) -> Void)?
    public var showBasket: (() -> Void)?
    public var onBasketUpdate: ((String?) -> Void)?
    
    // MARK: - Initializer
    
    init(dataProvider: ProductsProvidable, storage: BasketStorable) {
        self.dataProvider = dataProvider
        self.basketStorage = storage
        
        setupViewModels()
    }
    
    // MARK: - Public methods
    
    public func fetchProducts(with filter: String? = nil) {
        
        guard let viewModels = productsViewModels else {
            onError?("We couldn't find any products.")
            return
        }
        
        updateViewModels(viewModels: viewModels)
        
        if let filter = filter?.lowercased(), !filter.isEmpty {
            let filtered = viewModels.filter { $0.name.lowercased().contains(filter) || $0.categoryName.lowercased().contains(filter) }
            onFinish?(filtered)
        } else {
            onFinish?(viewModels)
        }
    }
    
    public func fetchBasket() {
        checkBasketPrice()
    }
    
    // MARK: - Private methods
    
    private func setupViewModels() {
        guard let products = dataProvider.loadProducts() else {
            productsViewModels = nil
            return
        }
        
        let productsViewModels = products.map { ProductViewModel(model: $0) }
        updateViewModels(viewModels: productsViewModels)
        self.productsViewModels = productsViewModels
    }
    
    private func updateViewModels(viewModels: [ProductViewModel]) {        
        for viewModel in viewModels {
            let storageItem: StorableItem? = basketStorage.element(for: viewModel.id)
            viewModel.basketCounter = storageItem?.counter ?? 0
            
            viewModel.basketCounterChanged = { [weak self] product, counter in
                self?.basketChangedHandler(with: product, counter: counter)
            }
        }
    }
    
    private func basketChangedHandler(with product: Product, counter: Int) {
        basketStorage.add(StorableItem(id: product.id, counter: counter))
        checkBasketPrice()
    }
    
    private func checkBasketPrice() {
        
        guard let productsViewModels = productsViewModels,
            !productsViewModels.isEmpty,
            let currency = productsViewModels.first?.price.currency else {
            onBasketUpdate?(nil)
            return
        }
        
        var prices: Double = 0.0
        var elements: Int = 0
        for viewModel in productsViewModels {
            let price = viewModel.summaryPrice.decimalNumber.doubleValue
            elements += viewModel.basketCounter
            prices += price
        }
        
        let formattedCounter = elements == 1 ? "Buy 1 product for " : "Buy \(elements) products for "
        let formattedPrice = prices.formatAsCurrency(currencyCode: currency)
        let text = formattedCounter + (formattedPrice ?? "")
        onBasketUpdate?(prices == 0 ? nil : text)
    }
}
