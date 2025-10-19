//
//  RouterError.swift
//  GitHubExplorer
//
//  Created by Malik Abdul Ghani on 17/10/25.
//

import Foundation

/// An error type representing possible failures when building or configuring API requests.
enum RouterError {
    /// Indicates that the provided base URL is invalid.
    case invalidBaseURL

    /// Indicates that the URL components (e.g., path or query items) are invalid.
    case invalidComponents
}

// MARK: - LocalizedError Conformance
extension RouterError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidBaseURL:
            "The provided base URL is invalid. Please check the URL configuration."
        case .invalidComponents:
            "Failed to build a valid URL from the given components. Please check the path or query parameters."
        }
    }
}
