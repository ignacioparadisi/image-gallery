//
//  HTTPClientTests.swift
//  ImageGalleryTests
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation
import Testing
@testable import ImageGallery

struct HTTPClientTests {
    @Test
    func requestHasAuthorizationHeader() async throws {
        let key = "test-key"
        let mockSession = MockSession { request in
            #expect(request.value(forHTTPHeaderField: "Authorization") == "Client-ID \(key)")
            #expect(request.httpMethod == "GET")
            
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (Data(#""data""#.utf8), response)
        }
        let client = HTTPClient(session: mockSession, accessKey: key)
        let response = try await client.request(endpoint: PhotosEndpoint(page: 1))
        #expect(response == "data")
    }
}

struct MockSession: HTTPSession {
    let handler: @Sendable (URLRequest) throws -> (Data, URLResponse)
    
    func data(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try handler(request)
    }
}
