//
//  ProductViewModelTests.swift
//  GroceryStoreTests
//
//  Created by Piotr Stanczak on 03/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import Foundation


import XCTest
@testable import GroceryStore

class ProductViewModelTests: XCTestCase, ProductsProviderTestable {
    
    private var bundle: Bundle!
    private let timeout: TimeInterval = 0.1
    
    override func setUp() {
        bundle = Bundle(for: type(of: self))
    }
    
    override func tearDown() {
        bundle = nil
    }
    
    func testProductViewModel() {
        let dataLoader = DataLoader(fileName: "ProductsCorrect", bundle: bundle)
        let productProvider = ProductsProvider(loader: dataLoader)
        
        guard let product = productProvider.loadProducts()?.first else {
            XCTFail("There should be at least one product")
            return
        }
        
        let productViewModel = ProductViewModel(model: product)
        
        XCTAssertTrue(productViewModel.identity == product.category.rawValue)
        XCTAssertTrue(productViewModel.id == product.id)
        XCTAssertTrue(productViewModel.name == product.name)
        XCTAssertTrue(productViewModel.categoryName == product.category.rawValue)
        XCTAssertTrue(productViewModel.price.amount == product.price.amount)
        XCTAssertTrue(productViewModel.priceString == product.price.priceString)
        productViewModel.basketCounter = 1
        XCTAssertTrue(productViewModel.summaryPrice.amount == product.price.amount)
        
        productViewModel.basketCounter = 3
        XCTAssertTrue(productViewModel.summaryPrice.amount == Decimal(floatLiteral: product.price.decimalNumber.doubleValue * 3.0))
        
        let stepperLabelTitle1 = productViewModel.stepperLabelTitle(for: 0)
        XCTAssertEqual(stepperLabelTitle1, "0 products")
        
        let stepperLabelTitle2 = productViewModel.stepperLabelTitle(for: 1)
        XCTAssertEqual(stepperLabelTitle2, "1 product")
    }
    
    func testProductViewModelCallbacks() {
        
        let expectationBasketChange = XCTestExpectation(description: "View model should call basket counter update")
        
        let dataLoader = DataLoader(fileName: "ProductsCorrect", bundle: bundle)
        let productProvider = ProductsProvider(loader: dataLoader)
        
        guard let product = productProvider.loadProducts()?.first else {
            XCTFail("There should be at least one product")
            return
        }
        
        let productViewModel = ProductViewModel(model: product)
        
        productViewModel.basketCounterChanged = { model, counter in
            expectationBasketChange.fulfill()
        }
        
        productViewModel.updateBasketValue(newValue: 3)
        
        wait(for: [expectationBasketChange], timeout: timeout)
    }
    
}
