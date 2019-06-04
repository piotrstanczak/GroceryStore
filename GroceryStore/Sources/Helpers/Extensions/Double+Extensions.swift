//
//  Double+Extensions.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import Foundation

extension Double {
    
    // Formats the receiver as a currency string using the specified three digit currencyCode. Currency codes are based on the ISO 4217 standard.    
    public func formatAsCurrency(currencyCode: String) -> String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = currencyCode
        currencyFormatter.maximumFractionDigits = floor(self) == self ? 0 : 2
        let currency = currencyFormatter.string(from: NSNumber(value: self))
        return currency
    }
}
