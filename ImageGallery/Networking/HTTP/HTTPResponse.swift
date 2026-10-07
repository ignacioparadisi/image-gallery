//
//  HTTPResponse.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import Foundation

nonisolated struct HTTPResponse<Body: Decodable> {
    typealias Headers = [String: String]
    let headers: Headers
    let statusCode: Int
    let body: Body
    
    init(body: Body, response: HTTPURLResponse) {
        self.body = body
        self.statusCode = response.statusCode
        var headers: [String: String] = [:]
        
        for (key, value) in response.allHeaderFields {
            if let key = key as? String, let value = value as? String {
                headers[key] = value
            }
        }
        self.headers = headers
    }
}
