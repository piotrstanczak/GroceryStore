//
//  Providable.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import Foundation

protocol DataProvidable {
    func fetchIfPossible<T>(_ fetcher: @autoclosure () throws ->(T?)) -> T?
}

extension DataProvidable {
    func fetchIfPossible<T>(_ fetcher: @autoclosure () throws ->(T?)) -> T? {
        do {
            return try fetcher()
        } catch let error {
            print("Error when trying to fetch data (\(error))")
            return nil
        }
    }
}




