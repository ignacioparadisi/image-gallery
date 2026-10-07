//
//  SearchPhotosEndpoint.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

/// Endpoint for searching photos
struct SearchPhotosEndpoint: Endpoint {
    typealias Response = PageDTO<PhotoDTO>
    
    /// Text for querying photos
    let text: String
    /// Page to be fetched
    let page: Int
    let pageSize: Int
    
    var path: String {
        return "/search/photos"
    }
    
    var parameters: [URLQueryItem] {
        return [
            URLQueryItem(name: "query", value: text),
            URLQueryItem(name: "page", value: String(describing: page)),
            URLQueryItem(name: "per_page", value: String(describing: pageSize))
        ]
    }
}
