//
//  DoubleExtensionsTests.swift
//  GroceryStoreTests
//
//  Created by Piotr Stanczak on 03/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import XCTest
@testable import GroceryStore

class DoubleExtensionsTests: XCTestCase {
    
    func testWhetherDoubleIsCorrectlyFormattedWithUSD() {
        let value: Double = 1.30
        let result = value.formatAsCurrency(currencyCode: "USD")
        XCTAssertEqual("$1.30", result)
    }
    
    func testWhetherDoubleIsCorrectlyFormattedWithPLN() {
        let value: Double = 1.30
        let result = value.formatAsCurrency(currencyCode: "PLN")
        XCTAssertEqual("PLN1.30", result)
    }
}
