//
//  CurrencyViewModel.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import UIKit

class CurrencyViewModel {
        
    let model: Currency
    
    init(model: Currency) {
        self.model = model
    }
    
    var identity: String {
        return model.currency
    }
    
    var name: String {
        return model.currency
    }
    
    var priceString: String {
        let currencyCode = model.currency
        return model.decimalNumber.doubleValue.formatAsCurrency(currencyCode: currencyCode) ?? ""
    }
    
    var price: Double {
        return model.decimalNumber.doubleValue
    }    
}
