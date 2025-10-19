//
//  RemoteDataSource.swift
//  GitHubExplorer
//
//  Created by Malik Abdul Ghani on 17/10/25.
//

import Foundation

/// A base protocol that outlines the core dependency required by any remote data source.
public protocol RemoteDataSource {
    /// A service used to send network requests and decode the responses.
    var apiService: any APIRequestable { get }
    
    /// Initializes the remote data source with a given API service.
    ///
    /// - Parameter apiService: The injected or shared service responsible for handling network calls.
    init(apiService: any APIRequestable)
}
