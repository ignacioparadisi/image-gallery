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
    
    @Test("Non 200..<300 status codes map to NetworkError", arguments: [
        (401, [String: String](), NetworkError.unauthozied),
        (403, ["X-Ratelimit-Remaining": "0"], .rateLimited),
        (403, [:], .httpError(statusCode: 403)),
        (404, [:], .httpError(statusCode: 404)),
        (500, [:], .httpError(statusCode: 500))
    ])
    func statusCodeMapping(statusCode: Int, headers: [String: String], expectedError: NetworkError) async {
        let session = MockSession { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: headers)!
            return (Data(), response)
        }
        let client = HTTPClient(session: session, accessKey: "test")
        await #expect(throws: expectedError) {
            let _ = try await client.request(endpoint: PhotosEndpoint(page: 1))
        }
    }
    
}

struct MockSession: HTTPSession {
    let handler: @Sendable (URLRequest) throws -> (Data, URLResponse)
    
    func data(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try handler(request)
    }
}
