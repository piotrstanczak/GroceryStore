//
//  CurrencyProviderTests.swift
//  GroceryStoreTests
//
//  Created by Piotr Stanczak on 03/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import XCTest
@testable import GroceryStore

protocol CurrencyProviderTestable: class {
    func getCurrencyProvider(with fileName: String) -> CurrencyProvider
}

extension CurrencyProviderTestable {
    func getCurrencyProvider(with fileName: String) -> CurrencyProvider {
        let mockRequestExecutor = RequestExecutorMock(localFileName: fileName)
        return CurrencyProvider(request: mockRequestExecutor)
    }
}


class CurrencyProviderTests: XCTestCase, CurrencyProviderTestable {
    
    private var sut: CurrencyProvider!
    private let timeout: TimeInterval = 0.1
    
    override func setUp() {
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testLoadingCurrenciesWhenFileDoesNotExist() {
        let expectationRequestFailed = XCTestExpectation(description: "Request should fail.")
        
        sut = getCurrencyProvider(with: "FakeFileName")
        sut.loadProducts { result in
            switch result {
            case .success:
                break
            case .failure:
                expectationRequestFailed.fulfill()
            }
        }
        
        wait(for: [expectationRequestFailed], timeout: timeout)
    }
    
    func testLoadingCurrenciesWithCorrectlyFormattedResponse() {
        let expectationRequestSucceeded = XCTestExpectation(description: "Result should finish with success.")
        
        let mockRequestExecutor = RequestExecutorMock(localFileName: "CurrenciesCorrect")
        sut = CurrencyProvider(request: mockRequestExecutor)
        sut.loadProducts { result in
            switch result {
            case .success:
                expectationRequestSucceeded.fulfill()
            case .failure:
                break
            }
        }
        
        wait(for: [expectationRequestSucceeded], timeout: timeout)
    }
    
    func testLoadingCurrenciesWithIncorrectlyFormattedResponse() {
        let expectationRequestFailed = XCTestExpectation(description: "Request should fail.")
        
        let mockRequestExecutor = RequestExecutorMock(localFileName: "CurrenciesIncorrect")
        sut = CurrencyProvider(request: mockRequestExecutor)
        sut.loadProducts { result in
            switch result {
            case .success:
                break
            case .failure:
                expectationRequestFailed.fulfill()
            }
        }
        
        wait(for: [expectationRequestFailed], timeout: timeout)
    }    
}
