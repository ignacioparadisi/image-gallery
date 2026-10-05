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
    
    @Test("Photos URL is correct") func testPhotosURL() {
        let expectedURL = URL(string: "https://api.unsplash.com/photos?page=1")
        let endpoint = PhotosEndpoint(page: 1)
        #expect(endpoint.url == expectedURL)
    }
    
    @Test("Search Photos URL is correct") func testSearchPhotosURL() {
        let expectedURL = URL(string: "https://api.unsplash.com/search/photos?query=Dog&page=1")
        let endpoint = SearchPhotosEndpoint(text: "Dog", page: 1)
        #expect(endpoint.url == expectedURL)
    }
}
