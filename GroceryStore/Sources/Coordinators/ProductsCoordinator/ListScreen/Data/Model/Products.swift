//
//  Product.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import Foundation
import UIKit

struct Products: Codable {
    let products: [Product]
}

struct Product: Codable {
    var id: String
    var name: String
    var category: CategortyType
    var price: Price
}

struct Price: Codable {
    var decimalNumber: NSDecimalNumber {
        get { return NSDecimalNumber(decimal: amount) }
        set { amount = newValue.decimalValue }
    }
    var amount: Decimal
    var currency: String
    
    enum CodingKeys: String, CodingKey {
        case amount
        case currency
    }
}

extension Price {
    var priceString: String? {
        return decimalNumber.doubleValue.formatAsCurrency(currencyCode: currency)
    }
}

extension Price {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let amountString = try container.decode(String.self, forKey: .amount)
        
        guard let amount = Decimal(string: amountString) else {
            fatalError()
        }
        self.amount = amount
        self.currency = try container.decode(String.self, forKey: .currency)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currency, forKey: .currency)
        try container.encode(amount, forKey: .amount)
    }
}

enum CategortyType: String, Codable {
    case vegetable = "Vegetable"
    case dairy = "Dairy"
    
    var icon: String {
        switch self {
        case .vegetable: return "icn_wegetables"
        case .dairy: return  "icn_dairy"
        }
    }
}
