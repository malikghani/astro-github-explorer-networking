//
//  Router.swift
//  GitHubExplorer
//
//  Created by Malik Abdul Ghani on 17/10/25.
//

import Foundation
import GithubExplorerUtils

/// A protocol that defines the requirements for constructing API endpoints in a type-safe manner.
public protocol Router {
    /// The base URL of the API endpoint.
    ///
    /// Defaults to `Constants.baseURL` in most cases.
    var baseURL: URL { get }

    /// The relative path of the API endpoint.
    var path: String { get }

    /// The parameters to include in the request.
    ///
    /// Defaults to an empty dictionary `[:]` if no parameters are required.
    var params: [String: Any] { get }

    /// The HTTP method to use when making the request.
    ///
    /// Defaults to `.get` if not explicitly overridden.
    var method: HTTPMethod { get }
}

// MARK: - Router Default Implementations
public extension Router {
    var baseURL: URL {
        Constants.baseURL
    }
    
    var params: [String: Any] {
        [:]
    }
    
    var method: HTTPMethod {
        .get
    }
}
