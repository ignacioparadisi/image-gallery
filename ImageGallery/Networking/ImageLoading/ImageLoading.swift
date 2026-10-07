//
//  ImageLoading.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation
import CoreGraphics

nonisolated protocol ImageLoading: Sendable {
    func cachedImage(url: URL?) -> CGImage?
    func image(url: URL?) async throws -> CGImage
}

nonisolated enum ImageLoaderError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case invalidData
}
