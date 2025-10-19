//
//  APIService.swift
//  GitHubExplorer
//
//  Created by Malik Abdul Ghani on 17/10/25.
//

import Foundation
import Network

/// Acts as the primary implementation of `APIRequestable`, responsible for sending network requests and decoding responses.
public final class APIService: APIRequestable {
    private let session: URLSession
    
    private let pathMonitor = NWPathMonitor()
    private let pathMonitorQueue = DispatchQueue(label: "com.malikghani.GithubExplorerNetworking.APIService.pathMonitor")
    private let pathStatusQueue = DispatchQueue(label: "com.malikghani.GithubExplorerNetworking.APIService.pathStatus", attributes: .concurrent)
    private var pathStatus: NWPath.Status = .requiresConnection
    
    private(set) var desc = ""
    
    public init(session: URLSession = .shared) {
        self.session = session
        startMonitoringPath()
    }
    
    public func send<T: Decodable, R: Router>(_ request: R, as object: T.Type) async throws -> T {
        guard hasNetworkConnection else {
            throw APIServiceError.noNetwork
        }
        
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
    
    deinit {
        pathMonitor.cancel()
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

// MARK: - Private helpers
private extension APIService {
    var hasNetworkConnection: Bool {
        pathStatusQueue.sync {
            pathStatus == .satisfied
        }
    }
    
    func startMonitoringPath() {
        pathMonitor.pathUpdateHandler = { [weak self] path in
            self?.store(path.status)
        }
        
        pathMonitor.start(queue: pathMonitorQueue)
        store(pathMonitor.currentPath.status)
    }
    
    func store(_ status: NWPath.Status) {
        pathStatusQueue.async(flags: .barrier) { [weak self] in
            self?.pathStatus = status
        }
    }
}

extension APIService: @unchecked Sendable {}
