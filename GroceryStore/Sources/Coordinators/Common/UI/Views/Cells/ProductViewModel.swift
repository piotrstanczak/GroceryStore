//
//  ProductViewModel.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

class ProductViewModel {
    
    // MARK: - Properties
    
    private let model: Product
    
    public var basketCounterChanged: ((Product, Int) -> Void)?
    public var basketCounter: Int = 0
    
    init(model: Product) {
        self.model = model
    }
    
    public var identity: String {
        return model.category.rawValue
    }
    
    public var id: String {
        return model.id
    }
    
    public var name: String {
        return model.name
    }
    
    public var categoryName: String {
        return model.category.rawValue
    }
    
    public var categoryIconName: String {
        return model.category.icon
    }
    
    public var priceString: String {
        let currencyCode = model.price.currency
        return model.price.decimalNumber.doubleValue.formatAsCurrency(currencyCode: currencyCode) ?? ""
    }
    
    public var price: Price {
        return model.price
    }
    
    public var summaryPrice: Price {
        let ammount = Double(basketCounter) * model.price.decimalNumber.doubleValue
        return Price(amount: Decimal(floatLiteral: ammount), currency: model.price.currency)
    }
    
    public func updateBasketValue(newValue: Int) {
        basketCounter = newValue
        basketCounterChanged?(model, basketCounter)
    }
    
    public func stepperLabelTitle(for value: Int) -> String {
        return value == 1 ? "\(value) product" : "\(value) products"
    }
}
