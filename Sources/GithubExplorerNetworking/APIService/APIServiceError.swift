//
//  APIServiceError.swift
//  GitHubExplorer
//
//  Created by Malik Abdul Ghani on 17/10/25.
//

import Foundation

/// An error type representing possible failures during API requests.
enum APIServiceError: Error {
    /// Indicates an error occurred while building or configuring the request.
    case router(RouterError)

    /// Indicates that the received response was not a valid `HTTPURLResponse`.
    case invalidResponse

    /// Indicates that the server responded with a non-successful HTTP status code.
    case http(code: Int, message: String?)
}

// MARK: - LocalizedError Conformance
extension APIServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .router(let routerError):
            routerError.localizedDescription
        case .invalidResponse:
            "The server response was not a valid HTTP response."
        case let .http(code, message):
            if let message, !message.isEmpty {
                "HTTP \(code): \(message)"
            } else {
                "HTTP \(code)"
            }
        }
    }
}
