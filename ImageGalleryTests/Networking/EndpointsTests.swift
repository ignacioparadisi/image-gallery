//
//  EndpointsTests.swift
//  ImageGalleryTests
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation
import Testing
@testable import ImageGallery

struct EndpointsTests {
    @Test("URL is built correctly", arguments: [
        (PhotosEndpoint(page: 1) as any Endpoint, "https://api.unsplash.com/photos?page=1"),
        (SearchPhotosEndpoint(text: "Dog", page: 1), "https://api.unsplash.com/search/photos?query=Dog&page=1"),
        (MockEndpoint(), "https://api.unsplash.com/stub")
    ])
    func urlIsBuiltCorrectly(endpoint: any Endpoint, expected: String) {
        #expect(endpoint.url?.absoluteString == expected)
    }
}

private struct MockEndpoint: Endpoint {
    typealias Response = String
    let path: String = "/stub"
}
