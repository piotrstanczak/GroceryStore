//
//  DataLoadable.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 01/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import Foundation

enum DataLoaderError: Error {
    case fileNotExist
}

protocol DataLoadable {
    func load<T: Codable>() throws -> T
}

class DataLoader: DataLoadable {
    private let fileName: String
    private let bundle: Bundle
    
    init(fileName: String, bundle: Bundle) {
        self.fileName = fileName
        self.bundle = bundle
    }
    
    func load<T: Codable>() throws -> T {
        
        guard let url = bundle.path(forResource: fileName, ofType: "plist") else {
            throw DataLoaderError.fileNotExist
        }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: url))
        let decoder = PropertyListDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
