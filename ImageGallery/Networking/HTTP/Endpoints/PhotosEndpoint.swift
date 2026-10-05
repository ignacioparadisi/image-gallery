//
//  PhotosEndpoint.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

/// Endpoint for fetching photos
struct PhotosEndpoint: Endpoint {
    typealias Response = String
    
    let page: Int
    
    var path: String {
        return "/photos"
    }
    
    var parameters: [URLQueryItem] {
        return [
            URLQueryItem(name: "page", value: String(describing: page))
        ]
    }
}
