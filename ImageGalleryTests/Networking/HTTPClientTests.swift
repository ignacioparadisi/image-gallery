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
        let authorization = "Client-ID test-key"
        let mockSession = MockSession { request in
            #expect(request.value(forHTTPHeaderField: "Authorization") == authorization)
            #expect(request.httpMethod == "GET")

            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let body = #"[{"id": "photo-1", "width": 100, "height": 100, "urls": {}}]"#
            return (Data(body.utf8), response)
        }
        let client = HTTPClient(session: mockSession, host: "api.unsplash.com", authorization: authorization)
        let response = try await client.request(endpoint: PhotosEndpoint(page: 1, pageSize: 30))
        #expect(response.body.map(\.id) == ["photo-1"])
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
        let client = HTTPClient(session: session, host: "api.unsplash.com", authorization: "test")
        await #expect(throws: expectedError) {
            let _ = try await client.request(endpoint: PhotosEndpoint(page: 1, pageSize: 30))
        }
    }

    @Test("URL errors map to NetworkError", arguments: [
        (URLError.Code.notConnectedToInternet, NetworkError.offline),
        (.networkConnectionLost, .offline),
        (.timedOut, .connectionFailed),
        (.cannotFindHost, .connectionFailed)
    ])
    func urlErrorMapping(code: URLError.Code, expectedError: NetworkError) async {
        let session = MockSession { _ in throw URLError(code) }
        let client = HTTPClient(session: session, host: "api.unsplash.com", authorization: "test")
        await #expect(throws: expectedError) {
            let _ = try await client.request(endpoint: PhotosEndpoint(page: 1, pageSize: 30))
        }
    }

    @Test func cancelledRequestThrowsCancellationError() async {
        let session = MockSession { _ in throw URLError(.cancelled) }
        let client = HTTPClient(session: session, host: "api.unsplash.com", authorization: "test")
        await #expect(throws: CancellationError.self) {
            let _ = try await client.request(endpoint: PhotosEndpoint(page: 1, pageSize: 30))
        }
    }

    @Test func invalidJSONThrowsDecodingFailed() async {
        let session = MockSession { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (Data("not json".utf8), response)
        }
        let client = HTTPClient(session: session, host: "api.unsplash.com", authorization: "test")
        await #expect(throws: NetworkError.decodingFailed) {
            let _ = try await client.request(endpoint: PhotosEndpoint(page: 1, pageSize: 30))
        }
    }

}

struct MockSession: HTTPSession {
    let handler: @Sendable (URLRequest) throws -> (Data, URLResponse)
    
    func data(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try handler(request)
    }
}
