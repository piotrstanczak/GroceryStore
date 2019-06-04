//
//  ProductsProviderTests.swift
//  GroceryStoreTests
//
//  Created by Piotr Stanczak on 03/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import XCTest
@testable import GroceryStore

protocol ProductsProviderTestable: class {
    func getProductProvider(with fileName: String) -> ProductsProvider
}

extension ProductsProviderTestable {
    func getProductProvider(with fileName: String) -> ProductsProvider {
        let dataLoader = DataLoader(fileName: fileName, bundle: Bundle(for: type(of: self)))
        let productProvider = ProductsProvider(loader: dataLoader)
        return productProvider
    }
}

class ProductsProviderTests: XCTestCase, ProductsProviderTestable {
    
    private var sut: ProductsProvider!
    private var bundle: Bundle!
    
    override func setUp() {
        bundle = Bundle(for: type(of: self))
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testLoadingCurrenciesWhenFileDoesNotExist() {
        // let dataLoader = DataLoader(fileName: "FakeFileName", bundle: bundle)
        let productProvider = getProductProvider(with: "FakeFileName")
        
        let results = productProvider.loadProducts()
        XCTAssertNil(results, "Result should be nil")
    }
    
    func testLoadingCorrectlyFormattedFile() {
        let dataLoader = DataLoader(fileName: "ProductsCorrect", bundle: bundle)
        let productProvider = ProductsProvider(loader: dataLoader)
        
        let results = productProvider.loadProducts()
        XCTAssertNotNil(results, "Products should not be nil")
    }
 
    func testLoadingIncorrectlyFormattedFile() {
        let dataLoader = DataLoader(fileName: "ProductsIncorrect", bundle: bundle)
        let productProvider = ProductsProvider(loader: dataLoader)
        
        let results = productProvider.loadProducts()
        XCTAssertNil(results, "Products should be nil")
    }
}
