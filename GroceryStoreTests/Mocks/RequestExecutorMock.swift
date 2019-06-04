//
//  MockDataLoader.swift
//  GroceryStoreTests
//
//  Created by Piotr Stanczak on 03/06/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import Foundation

@testable import GroceryStore

class RequestExecutorMock: RequestExecutor {
    
    let localFileName: String
    
    init(localFileName: String) {
        self.localFileName = localFileName
        
        super.init(urlSession: URLSession(), baseUrl: "fakeBaseUrl")
    }
    
    override func load<T>(callback: @escaping (Result<T, NetworkingError>) -> Void) where T : Decodable, T : Encodable {
    
        guard let decodedLocalFile: T = loadLocalData(jsonFile: localFileName) else {
            callback(.failure(.generalError))
            return
        }
        
        callback(.success(decodedLocalFile))
    }
    
    private func loadLocalData<T: Codable>(jsonFile: String, withExtension: String = "json") -> T? {
        let decoder = JSONDecoder()
        let fileBundle = Bundle(for: type(of: self))
        guard let fileUrl = fileBundle.url(forResource: jsonFile, withExtension: withExtension)
            else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            let jsonData = try decoder.decode(T.self, from: data)
            return jsonData
        } catch {
            return nil
        }
    }
}
