//
//  PhotosEndpoint.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

public struct PhotosEndpoint: Endpoint {
    let page: Int
    
    public var path: String {
        return "/photos"
    }
    
    public var parameters: [URLQueryItem] {
        return [
            URLQueryItem(name: "page", value: String(describing: page))
        ]
    }
}
