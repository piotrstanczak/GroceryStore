//
//  BasketStorageTests.swift
//  GroceryStoreTests
//
//  Created by Piotr Stanczak on 03/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import XCTest
@testable import GroceryStore

protocol BasketStorageTestable: class {
    func getBasketStorage(with key: String) -> BasketStorage
}

extension BasketStorageTestable {
    func getBasketStorage(with key: String) -> BasketStorage {
        let userDefaults = UserDefaultsMock(suiteName: "MockDefaults") ?? UserDefaults()
        let basketStorage = BasketStorage(with: userDefaults, storageKey: key)
        return basketStorage
    }
}

class BasketStorageTests: XCTestCase, BasketStorageTestable {
    
    private var sut: BasketStorage!
    private var userDefaults: UserDefaultsMock!
    
    override func setUp() {
        userDefaults = UserDefaultsMock(suiteName: "MockDefaults")
    }
    
    override func tearDown() {
        sut = nil
        userDefaults = nil
    }
    
    func testStorageWhenItemDoesNotExist() {
        let basketStorage = getBasketStorage(with: "basket")
        
        let storageItem: StorableItem? = basketStorage.element(for: "id")
        XCTAssertNil(storageItem)
    }
    
    func testStorageWhenAddingNewItems() {
        let basketStorage = BasketStorage(with: userDefaults, storageKey: "basket")
        let inputItem = StorableItem(id: "id1", counter: 2)
        basketStorage.add(inputItem)
        
        guard let resultItem: StorableItem = basketStorage.element(for: inputItem.id) else {
            XCTFail("Item should not be nil")
            return
        }
        
        XCTAssertEqual(inputItem.counter, resultItem.counter, "Items should be equal")
    }
    
    func testStorageWhenUpdatingItems() {
        let id = "id1"
        let basketStorage = BasketStorage(with: userDefaults, storageKey: "basket")
        let inputItem1 = StorableItem(id: id, counter: 2)
        basketStorage.add(inputItem1)
        
        let inputItem2 = StorableItem(id: id, counter: 3)
        basketStorage.add(inputItem2)
        
        guard let resultItem: StorableItem = basketStorage.element(for: id) else {
            XCTFail("Item should not be nil")
            return
        }
        
        XCTAssertEqual(inputItem2.counter, resultItem.counter, "Items should be equal")
    }
    
    func testStorageWhenRemovingItems() {
        let basketStorage = BasketStorage(with: userDefaults, storageKey: "basket")
        
        let inputItem = StorableItem(id: "id1", counter: 2)
        basketStorage.add(inputItem)
        basketStorage.remove(inputItem)
        
        let resultItem: StorableItem? = basketStorage.element(for: inputItem.id)
        
        XCTAssertNil(resultItem, "Item should be nil")
    }
}

