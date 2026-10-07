//
//  HTTPResponse.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import Foundation

nonisolated struct HTTPResponse<Body: Decodable> {
    let statusCode: Int
    let body: Body
    private let headers: [String: String]

    init(body: Body, response: HTTPURLResponse) {
        self.body = body
        self.statusCode = response.statusCode
        var headers: [String: String] = [:]

        for (key, value) in response.allHeaderFields {
            if let key = key as? String, let value = value as? String {
                headers[key.lowercased()] = value
            }
        }
        self.headers = headers
    }

    /// Header names are case-insensitive, and servers don't all send them with the same casing.
    func header(_ name: String) -> String? {
        headers[name.lowercased()]
    }
}
