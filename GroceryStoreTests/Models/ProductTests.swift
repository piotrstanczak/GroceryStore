//
//  ProductTests.swift
//  GroceryStoreTests
//
//  Created by Piotr Stanczak on 03/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import XCTest
@testable import GroceryStore

class ProductTests: XCTestCase, ProductsProviderTestable {

    private var bundle: Bundle!
    
    override func setUp() {
        bundle = Bundle(for: type(of: self))
    }
    
    override func tearDown() {
        bundle = nil
    }
    
    func testWhetherProductsAreDecodedProperly() {
        let dataLoader = DataLoader(fileName: "ProductsCorrect", bundle: bundle)
        let productProvider = ProductsProvider(loader: dataLoader)
        
        guard let product = productProvider.loadProducts()?.first else {
            XCTFail("There should be at least one product")
            return
        }
        
        XCTAssertTrue(product.id == "0")
        XCTAssertTrue(product.name == "Peas")
        XCTAssertTrue(product.category == .vegetable)
        XCTAssertTrue(product.category.icon == "icn_wegetables")
        XCTAssertTrue(product.price.amount == Decimal(floatLiteral: 0.95))
        XCTAssertTrue(product.price.decimalNumber == 0.95)
        XCTAssertTrue(product.price.currency == "USD")
        XCTAssertTrue(product.price.priceString == "$0.95")
    }
    
}
