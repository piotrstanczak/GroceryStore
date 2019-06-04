//
//  DataLoaderTests.swift
//  GroceryStoreTests
//
//  Created by Piotr Stanczak on 03/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import XCTest
@testable import GroceryStore

class DataLoaderTests: XCTestCase {
    
    var sut: DataLoader!
    var bundle: Bundle!
    
    override func setUp() {
        bundle = Bundle(for: type(of: self))
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testLoadingWhenDoesNotExist() {
        sut = DataLoader(fileName: "FakeFileName", bundle: bundle)
        do {
            let _: Products = try sut.load()
            XCTFail("Load should throw an error")
        } catch DataLoaderError.fileNotExist {
        } catch {
            XCTFail("Error should be 'fileNotExist'")
        }
    }
    
    func testLoadingCorrectlyFormattedFile() {
        sut = DataLoader(fileName: "ProductsCorrect", bundle: bundle)
        do {
            let products: Products? = try sut.load()
            XCTAssertNotNil(products)
        } catch {
            XCTFail("Load should not throw an error")
        }        
    }
    
    func testLoadingIncorrectlyFormattedFile() {
        sut = DataLoader(fileName: "ProductsIncorrect", bundle: bundle)
        do {
            let _: Products? = try sut.load()
            XCTFail("Load should not throw an error")
        } catch DecodingError.keyNotFound {
        } catch {
            XCTFail("Error should be 'keyNotFound'")
        }
    }
}

