//
//  URLSession+Image.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import Foundation

extension URLSession {
    static let images: URLSession = {
        let cacheDirectory = FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask).first?
            .appending(path: "ImageCache")
        
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(
            memoryCapacity: 10 * 1024 * 1024,
            diskCapacity: 200 * 1024 * 1024,
            directory: cacheDirectory
        )
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: configuration)
    }()
}
