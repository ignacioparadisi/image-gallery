//
//  SearchPhotosEndpoint.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

public struct SearchPhotosEndpoint: Endpoint {
    public let text: String
    public let page: Int
    
    public var path: String {
        return "/search/photos"
    }
    
    public var parameters: [URLQueryItem] {
        return [
            URLQueryItem(name: "query", value: text),
            URLQueryItem(name: "page", value: String(describing: page))
        ]
    }
}
