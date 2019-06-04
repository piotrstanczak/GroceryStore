//
//  Currencies.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import Foundation

struct Currencies: Codable {
    let success: Bool
    let quotes: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case success
        case quotes
    }
}

extension Currencies {
    var currencies: [Currency] {        
        return quotes.map{ key, value in
            let type = key.dropFirst(3)
            let amount = Decimal(floatLiteral: value)
            return Currency(currency: String(type), amount: amount)
        }
    }
}

struct Currency {
    let currency: String
    var amount: Decimal
    
    var decimalNumber: NSDecimalNumber {
        get { return NSDecimalNumber(decimal: amount) }
        set { amount = newValue.decimalValue }
    }
}


