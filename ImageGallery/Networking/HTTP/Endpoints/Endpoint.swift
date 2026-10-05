//
//  Endpoint.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
}

public enum HTTPScheme: String {
    case https = "https"
}

public protocol Endpoint {
    var method: HTTPMethod { get }
    var scheme: HTTPScheme { get }
    var host: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var body: Encodable? { get }
}

public extension Endpoint {
    var method: HTTPMethod { .get }
    var scheme: HTTPScheme { .https }
    var host: String { "api.unsplash.com" }
    var parameters: [URLQueryItem] { [] }
    var body: Encodable? { nil }
}

public extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host
        components.path = path
        components.queryItems = parameters
        return components.url
    }
}
