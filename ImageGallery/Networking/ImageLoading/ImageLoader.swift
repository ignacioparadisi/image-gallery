//
//  ImageLoader.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import Foundation
import OSLog
import ImageIO

actor ImageLoader: ImageLoading {
    private let logger = Logger(subsystem: "ImageLoader", category: "Cache")
    private let session: HTTPSession
    nonisolated(unsafe) private let cache = NSCache<NSURL, CGImage>()
    private var loadingTasks: [URL: Task<CGImage, Error>] = [:]
    
    init(session: HTTPSession, countLimit: Int = 200) {
        self.session = session
        self.cache.countLimit = countLimit
    }
    
    nonisolated func cachedImage(url: URL?) -> CGImage? {
        guard let url else { return nil }
        return cache.object(forKey: url as NSURL)
    }
    
    func image(url: URL?) async throws -> CGImage {
        guard let url else { throw ImageLoaderError.invalidURL }
        if let cached = cache.object(forKey: url as NSURL) {
            logger.debug("Fetch image from Cache: \(url.lastPathComponent)")
            return cached
        }
        if let task = loadingTasks[url] {
            logger.debug("Fetch already loading image: \(url.lastPathComponent)")
            return try await task.value
        }
        
        let task = Task { [session] in
            try await Self.download(url, session: session)
        }
        loadingTasks[url] = task
        defer { loadingTasks[url] = nil }
        
        let image = try await task.value
        cache.setObject(image, forKey: url as NSURL)
        logger.debug("Did fetch image from network: \(url.lastPathComponent)")
        return image
    }
    
    @concurrent
    private nonisolated static func download(_ url: URL, session: HTTPSession) async throws -> CGImage {
        let (data, response) = try await session.data(URLRequest(url: url))
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            throw ImageLoaderError.invalidResponse
        }
        
        return try decode(data)
    }
    
    private nonisolated static func decode(_ data: Data) throws -> CGImage {
        let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let source = CGImageSourceCreateWithData(data as CFData, sourceOptions) else {
            throw ImageLoaderError.invalidData
        }
        let options = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true
        ] as CFDictionary
        guard let image = CGImageSourceCreateThumbnailAtIndex(source, 0, options) else {
            throw ImageLoaderError.invalidData
        }
        return image
    }
}
