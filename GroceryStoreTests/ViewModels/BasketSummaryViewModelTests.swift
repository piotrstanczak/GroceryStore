//
//  BasketSummaryViewModelTests.swift
//  GroceryStoreTests
//
//  Created by Piotr Stanczak on 03/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import XCTest
@testable import GroceryStore

protocol BasketSummaryViewModelTestble: ProductsProviderTestable, BasketStorageTestable {
    func getViewModel(with fileName: String, basketStorage: BasketStorage?) -> BasketSummaryViewModel
}

extension BasketSummaryViewModelTestble {
    func getViewModel(with fileName: String, basketStorage: BasketStorage? = nil) -> BasketSummaryViewModel {
        let fakeBasketStorage = getBasketStorage(with: "basket")
        let productProvider = getProductProvider(with: fileName)
        return BasketSummaryViewModel(dataProvider: productProvider, storage: basketStorage ?? fakeBasketStorage)
    }
}

class BasketSummaryViewModelTests: XCTestCase, BasketSummaryViewModelTestble {
    private var sut: BasketSummaryViewModel!
    private let timeout: TimeInterval = 0.1
    
    override func setUp() {
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testWhetherErrorIsCalledWhenDataIsIncorrected() {
        let expectationProviderError = XCTestExpectation(description: "Provider should finish with an error")
        
        sut = getViewModel(with: "FakeFile")
        
        sut.onError = { error in
            expectationProviderError.fulfill()
        }
        
        sut.fetchProducts()
        
        wait(for: [expectationProviderError], timeout: timeout)
    }
    
    func testWhetherFinishIsCalledWhenDataIsCorrectButBasketIsEmpty() {
        let expectationProviderEmptyData = XCTestExpectation(description: "Provider should finish with empty data")
        
        sut = getViewModel(with: "ProductsCorrect")
        
        sut.onFinish = { products in            
            XCTAssertTrue(products.isEmpty)
            expectationProviderEmptyData.fulfill()
        }
        
        sut.fetchProducts()
        
        wait(for: [expectationProviderEmptyData], timeout: timeout)
    }
    
    func testWhetherBasketIsUpdatedWhenDataIsCorrectAndProductsAreInBasket() {
        let expectationProviderBasketUpdateWithValue = XCTestExpectation(description: "Should update basket with value")
        
        let basketStorage = getBasketStorage(with: "basket")
        basketStorage.add(StorableItem(id: "0", counter: 3))
        
        sut = getViewModel(with: "ProductsCorrect", basketStorage: basketStorage)
        sut.onBasketUpdate = { value in
            XCTAssertNotNil(value)
            expectationProviderBasketUpdateWithValue.fulfill()
        }
        
        sut.fetchProducts()
        sut.fetchBasket()
        
        wait(for: [expectationProviderBasketUpdateWithValue], timeout: 1.0)
    }
    
    func testWhetherBasketIsCorrectlyUpdated() {
        let expectationProviderBasketUpdateWithValue = XCTestExpectation(description: "Should update basket with value")
        
        let (basketStorage, expectedPrice) = prepareBasketWithItemsInIt()
        
        sut = getViewModel(with: "ProductsCorrect", basketStorage: basketStorage)
        sut.onBasketUpdate = { value in
            XCTAssertNotNil(value)
            guard let value = value else {
                XCTFail("Price should not be nil")
                return
            }
            XCTAssertEqual(value.decimalNumber.doubleValue, expectedPrice)
            
            expectationProviderBasketUpdateWithValue.fulfill()
        }
        
        sut.fetchProducts()
        sut.fetchBasket()
        
        wait(for: [expectationProviderBasketUpdateWithValue], timeout: 1.0)
    }
    
    func testWhetherBasketIsCorrectlyUpdatedAfterCurrencyChanged() {
        let expectationProviderBasketUpdateWithValue = XCTestExpectation(description: "Should update basket with value")
        
        let (basketStorage, expectedPrice) = prepareBasketWithItemsInIt()
        let currencyRate = 3.80
        
        sut = getViewModel(with: "ProductsCorrect", basketStorage: basketStorage)
        sut.onBasketUpdate = { value in
            XCTAssertNotNil(value)
            guard let value = value else {
                XCTFail("Price should not be nil")
                return
            }
            
            XCTAssertEqual(value.amount, Decimal(floatLiteral: expectedPrice * currencyRate))
            expectationProviderBasketUpdateWithValue.fulfill()
        }
        
        
        sut.fetchProducts()
        let currency = Currency(currency: "PLN", amount: Decimal(floatLiteral: currencyRate))
        sut.onCurrencyChange(currency: currency)
        
        wait(for: [expectationProviderBasketUpdateWithValue], timeout: 1.0)
    }
    
    // MARK: Helpers
    
    private func prepareBasketWithItemsInIt() -> (BasketStorage, Double) {
        let basketStorage = getBasketStorage(with: "basket")
        var expectedPrice: Double = 0.0
        guard let products = getProductProvider(with: "ProductsCorrect").loadProducts() else {
            return (basketStorage, expectedPrice)
        }
        
        for product in products {
            basketStorage.add(StorableItem(id: product.id, counter: 1))
            expectedPrice += product.price.decimalNumber.doubleValue
        }
        
        return (basketStorage, expectedPrice)
    }
}
