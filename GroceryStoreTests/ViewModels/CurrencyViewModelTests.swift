//
//  CurrencyViewModelTests.swift
//  GroceryStoreTests
//
//  Created by Piotr Stanczak on 03/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import XCTest
@testable import GroceryStore

class CurrencyViewModelTests: XCTestCase, CurrencyProviderTestable {
    
    private var sut: CurrencyProvider!
    private let timeout: TimeInterval = 0.1
    
    func testWhetherCurrenciesAreDecodedProperly() {
        
        let expectationViewModelInitialization = XCTestExpectation(description: "Result should finish with success.")
        
        let mockRequestExecutor = RequestExecutorMock(localFileName: "CurrenciesCorrect")
        sut = CurrencyProvider(request: mockRequestExecutor)
        sut.loadProducts { result in
            switch result {
            case .success(let currencie):
                
                XCTAssertTrue(currencie.success)
                
                guard let currency = currencie.currencies.first(where: {$0.currency == "PLN"} ) else {
                    XCTFail("There should be at least on currency")
                    return
                }
                
                let currencyViewModel = CurrencyViewModel(model: currency)
                
                XCTAssertEqual(currencyViewModel.identity, currency.currency, "Should be equal")
                XCTAssertEqual(currencyViewModel.price, currency.decimalNumber.doubleValue, "Should be equal")
                
                
                expectationViewModelInitialization.fulfill()
            case .failure:
                break
            }
        }
        
        wait(for: [expectationViewModelInitialization], timeout: timeout)
    }
    
}
