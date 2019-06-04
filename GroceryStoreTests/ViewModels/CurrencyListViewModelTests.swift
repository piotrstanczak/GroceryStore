//
//  CurrencyListViewModelTests.swift
//  GroceryStoreTests
//
//  Created by Piotr Stanczak on 03/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import XCTest
@testable import GroceryStore

protocol CurrencyListViewModelTestble: CurrencyProviderTestable {
    func getViewModel(with fileName: String) -> CurrencyListViewModel
}

extension CurrencyListViewModelTestble {
    
    func getViewModel(with fileName: String) -> CurrencyListViewModel {
        let provider = getCurrencyProvider(with: fileName)
        return CurrencyListViewModel(dataProvider: provider)
    }
}

class CurrencyListViewModelTests: XCTestCase, CurrencyListViewModelTestble {
    
    private var sut: CurrencyListViewModel!
    private let timeout: TimeInterval = 0.1
    
    override func setUp() {
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testWhetherErrorIsCalledWhenDataIsIncorrected() {
        let expectationProviderError = XCTestExpectation(description: "Provider should finish with an error")
        let expectationProviderStartLoading = XCTestExpectation(description: "Provider should start loading")
        let expectationProviderFinishLoading = XCTestExpectation(description: "Provider should finish loading")
        
        sut = getViewModel(with: "FakeFile")
        
        sut.onError = { error in
            expectationProviderError.fulfill()
        }
        
        sut.onStartLoading = {
            expectationProviderStartLoading.fulfill()
        }
        
        sut.onFinishLoading = {
            expectationProviderFinishLoading.fulfill()
        }
        
        sut.fetchData()
        
        wait(for: [expectationProviderError, expectationProviderStartLoading, expectationProviderFinishLoading], timeout: timeout)
    }
    
    func testWhetherViewModelWillFinishLoading() {
        let expectationProviderSuccess = XCTestExpectation(description: "Provider should finish with with success")
        let expectationProviderStartLoading = XCTestExpectation(description: "Provider should start loading")
        let expectationProviderFinishLoading = XCTestExpectation(description: "Provider should finish loading")
        
        sut = getViewModel(with: "CurrenciesCorrect")
        
        sut.onFinish = { results in
            XCTAssertTrue(!results.isEmpty, "Results should not be empty")
            expectationProviderSuccess.fulfill()
        }
        
        sut.onStartLoading = {
            expectationProviderStartLoading.fulfill()
        }
        
        sut.onFinishLoading = {
            expectationProviderFinishLoading.fulfill()
        }
        
        sut.fetchData()
        
        wait(for: [expectationProviderSuccess, expectationProviderStartLoading, expectationProviderFinishLoading], timeout: 1.0)
    }
    
    func testWhetherViewModelWillFinishLoadingWithFilter() {
        let expectationProviderSuccess = XCTestExpectation(description: "Provider should finish with with success")
        
        sut = getViewModel(with: "CurrenciesCorrect")
        
        sut.onFinish = { results in
            XCTAssertTrue(!results.isEmpty, "Results should not be empty")
            XCTAssertTrue(results.count == 1, "Results should have only one element")
            expectationProviderSuccess.fulfill()
        }
        
        sut.fetchData(with: "PLN")        
        
        wait(for: [expectationProviderSuccess], timeout: 1.0)
    }
}
