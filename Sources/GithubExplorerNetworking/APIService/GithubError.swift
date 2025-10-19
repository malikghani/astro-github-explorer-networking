//
//  GithubError.swift
//  GitHubExplorer
//
//  Created by Malik Abdul Ghani on 17/10/25.
//

import Foundation

/// A model representing an error response returned by the GitHub REST API.
struct GitHubAPIError: Decodable {
    /// A human-readable message describing the error.\
    let message: String
    
    /// A URL pointing to GitHub documentation that provides more context about the error.
    let documentationUrl: String?
}
