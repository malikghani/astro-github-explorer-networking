//
//  APIService.swift
//  GitHubExplorer
//
//  Created by Malik Abdul Ghani on 17/10/25.
//

import Foundation

/// Acts as the primary implementation of `APIRequestable`, responsible for sending network requests and decoding responses.
public final class APIService: APIRequestable {
    private let session: URLSession
    private(set) var desc = ""
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func send<T: Decodable, R: Router>(_ request: R, as object: T.Type) async throws -> T {
        let urlRequest = try buildRequest(for: request)
        let (data, response) = try await session.data(for: urlRequest)
               
        guard let http = response as? HTTPURLResponse else {
            throw APIServiceError.invalidResponse
        }
               
        guard (200..<300).contains(http.statusCode) else {
            let apiError = try? JSONDecoder().decode(GitHubAPIError.self, from: data)
            throw APIServiceError.http(code: http.statusCode, message: apiError?.message)
        }
        
        return try decode(data)
    }
}

// MARK: - Public Functionality
public extension APIService {
    /// Returns a default, shared instance of `APIService` configured with `URLSession.shared`.
    static var `default`: APIService {
        let service = APIService()
        service.desc = "default"
        
        return service
    }
    
    /// Returns a mocked, shared instance of `APIService` configured with `URLSession.shared`.
    static var mocked: APIService {
        let service = APIService()
        service.desc = "mocked"
        
        return service
    }
}
