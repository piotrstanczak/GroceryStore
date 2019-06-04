//
//  NetworkManager.swift
//  GroceryStore
//
//  Created by Piotr Stanczak on 31/05/2019.
//  Copyright © 2019 Piotr Stanczak. All rights reserved.
//

import Foundation

enum NetworkingError: Error {
    case generalError
    case couldNotEncodeUrl
    case couldNotDecodeData
    case badStatus
}

extension NetworkingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .generalError:
            return "General error"
        case .couldNotEncodeUrl:
            return "Wrong url :|"
        case .couldNotDecodeData:
            return "Data format issue"
        case .badStatus:
            return "Http issue with status code"
        }        
    }
}

protocol RequestExecutable {
    func load<T: Codable>(callback: @escaping (Result<T, NetworkingError>) -> Void)
}

class RequestExecutor: RequestExecutable {
    
    // MARK: - Properties
    private let baseUrl: String
    private let urlSession: URLSession
    
    init(urlSession: URLSession, baseUrl: String) {
        self.urlSession = urlSession
        self.baseUrl = baseUrl
    }
    
    // MARK: - Public methods
    
    /// - Returns: a 'Result' with model of type T that conforms to Codable protocol or an Error
    func load<T: Codable>(callback: @escaping (Result<T, NetworkingError>) -> Void) {

        guard let url = URL(string: baseUrl) else {
            callback(.failure(.couldNotEncodeUrl))
            return
        }

        let task = urlSession.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                callback(.failure(.generalError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                callback(.failure(.badStatus))
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                callback(.failure(.generalError))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                callback(.success(decoded))
            } catch {
                callback(.failure(.couldNotDecodeData))
            }
        }
        
        task.resume()
    }
}

