//
//  ProductsListViewModelTests.swift
//  GroceryStoreTests
//
//  Created by Piotr Stanczak on 03/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import XCTest
@testable import GroceryStore

protocol ProductsListViewModelTestble: ProductsProviderTestable, BasketStorageTestable {
    func getViewModel(with fileName: String, basketStorage: BasketStorage?) -> ProductsListViewModel
}

extension ProductsListViewModelTestble {
    
    func getViewModel(with fileName: String, basketStorage: BasketStorage? = nil) -> ProductsListViewModel {
        let fakeBasketStorage = getBasketStorage(with: "basket")
        let productProvider = getProductProvider(with: fileName)
        return ProductsListViewModel(dataProvider: productProvider, storage: basketStorage ?? fakeBasketStorage)
    }
}

class ProductsListViewModelTests: XCTestCase, ProductsListViewModelTestble {
    private var sut: ProductsListViewModel!
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
    
    func testWhetherFinishIsCalledWhenDataIsCorrect() {
        let expectationProviderError = XCTestExpectation(description: "Provider should finish with data")
        
        sut = getViewModel(with: "ProductsCorrect")
        
        sut.onFinish = { products in            
            XCTAssertTrue(!products.isEmpty)
            expectationProviderError.fulfill()
        }
        
        sut.fetchProducts()
        
        wait(for: [expectationProviderError], timeout: timeout)
    }
    
    func testWhetherFinishIsCalledWhenDataIsCorrectWithFilter() {
        let expectationProviderError = XCTestExpectation(description: "Provider should finish with data")
        
        sut = getViewModel(with: "ProductsCorrect")
        
        sut.onFinish = { products in
            XCTAssertTrue(products.count == 1)
            expectationProviderError.fulfill()
        }
        
        sut.fetchProducts(with: "Bean")
        
        wait(for: [expectationProviderError], timeout: timeout)
    }
    
    func testWhetherBasketIsUpdatedWhenDataIsCorrectButNothingInBasket() {
        let expectationProviderBasketUpdate = XCTestExpectation(description: "Should update basket with empty value")
        sut = getViewModel(with: "ProductsCorrect")
        
        sut.onBasketUpdate = { value in
            
            XCTAssertNil(value)
            expectationProviderBasketUpdate.fulfill()
        }
        
        sut.fetchBasket()
        
        wait(for: [expectationProviderBasketUpdate], timeout: timeout)
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
}
