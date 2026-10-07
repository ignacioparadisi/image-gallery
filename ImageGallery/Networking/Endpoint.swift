//
//  Endpoint.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

nonisolated protocol Endpoint: Sendable {
    associatedtype Response: Decodable & Sendable
    
    /// HTTP Method for the enpoint. `GET`,  `POST`, `PUT`, `DELETE`
    var method: HTTPMethod { get }
    /// Scheme for the request. `HTTPS`,  `HTTP`
    var scheme: HTTPScheme { get }
    /// Path for the endpoint
    var path: String { get }
    /// Parameters sent in the request
    var parameters: [URLQueryItem] { get }
    /// Body sent in the request
    var body: Encodable? { get }
}

extension Endpoint {
    var method: HTTPMethod { .get }
    var scheme: HTTPScheme { .https }
    var host: String { "api.unsplash.com" }
    var parameters: [URLQueryItem] { [] }
    var body: Encodable? { nil }
}

nonisolated extension Endpoint {
    /// URL created from the endpoint
    func url(host: String) -> URL? {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host
        components.path = path
        components.queryItems = parameters.isEmpty ? nil : parameters
        return components.url
    }
}
