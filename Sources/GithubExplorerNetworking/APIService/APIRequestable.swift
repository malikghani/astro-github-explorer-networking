//
//  APIRequestable.swift
//  GitHubExplorer
//
//  Created by Malik Abdul Ghani on 17/10/25.
//

import Foundation

/// A protocol that defines the core responsibilities for executing API requests.
public protocol APIRequestable {
    /// Creates a new instance of the API service with a specific `URLSession`.
    ///
    /// - Parameter session: The `URLSession` instance used to perform network requests.
    init(session: URLSession)
    
    /// Sends an HTTP request to the specified API endpoint and decodes the response into a strongly typed model.
    ///
    /// - Parameters:
    ///   - request: A type conforming to `Router` that describes the API endpoint.
    ///   - object: The expected response model type conforming to `Codable`.
    /// - Returns: A decoded object of type `T` representing the API response.
    /// - Throws: `RouterError` if request construction fails, or `APIServiceError` for network/decoding failures.
    func send<T: Codable>(_ request: some Router, as object: T.Type) async throws -> T

    /// Builds the URL query parameters to be used in the API request.
    ///
    /// - Parameter request: A type conforming to `Router` that contains the parameters.
    /// - Returns: An array of `URLQueryItem` representing the query parameters.
    /// - Throws: `RouterError` if parameter encoding fails or values are invalid.
    func buildParameters(from request: some Router) throws -> [URLQueryItem]
    
    /// Builds a complete `URLRequest` from a given `Router`.
    ///
    /// - Parameter router: A type conforming to `Router` that defines the endpoint.
    /// - Returns: A fully constructed `URLRequest`.
    /// - Throws: `RouterError` if the URL or components are invalid.
    func buildRequest(for router: some Router) throws -> URLRequest

    /// Decodes raw `Data` into a strongly typed `Decodable` model.
    ///
    /// - Parameter data: The raw response data to decode.
    /// - Returns: A decoded object of the specified generic type `T`.
    /// - Throws: A decoding error if the data does not match the expected structure.
    func decode<T: Decodable>(_ data: Data) throws -> T
}

// MARK: - APIRequestable Default Implementation
public extension APIRequestable {
    func buildParameters(from request: some Router) throws -> [URLQueryItem] {
        request.params.map { key, value in
            URLQueryItem(name: key, value: String(describing: value))
        }
    }
    
    func buildRequest(for router: some Router) throws -> URLRequest {
        guard var components = URLComponents(url: router.baseURL, resolvingAgainstBaseURL: false) else {
            throw APIServiceError.router(.invalidBaseURL)
        }
        
        components.path = router.path
        components.queryItems = try buildParameters(from: router)
        
        guard let url = components.url else {
            throw APIServiceError.router(.invalidComponents)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = router.method.rawValue
        
        return request
    }
    
    func decode<T: Decodable>(_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(T.self, from: data)
    }
}
