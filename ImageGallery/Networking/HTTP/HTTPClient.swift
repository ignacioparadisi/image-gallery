//
//  HTTPClient.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation
import OSLog

// TODO: Move networking to a package so I don't have to use nonisolated everywhere

/// Sends requests to the Unsplash API and decodes their responses.
struct HTTPClient: APIClient {
    private let logger = Logger(subsystem: "HTTPClient", category: "Network")
    /// Performs the requests. Tests pass a fake one.
    private let session: HTTPSession
    /// The API host, for example `api.unsplash.com`.
    private let host: String
    /// Access key, sent in the `Authorization` header of every request.
    private let authorization: String

    init(session: HTTPSession = URLSession.shared, host: String, authorization: String) {
        self.session = session
        self.host = host
        self.authorization = authorization
    }
    
    /// Sends the request and decodes the body into the endpoint's response type.
    ///
    /// Runs off the main actor so decoding doesn't block the UI.
    @concurrent
    func request<E: Endpoint>(endpoint: E) async throws -> HTTPResponse<E.Response> {
        logger.debug("Requesting from \(endpoint.url(host: host)?.absoluteString ?? "")")
        let (data, response) = try await data(from: endpoint)
        let body = try JSONDecoder().decode(E.Response.self, from: data)
        return HTTPResponse(body: body, response: response)
    }
    
    /// Sends the request and returns the raw body, throwing for non-2xx responses.
    func data(from endpoint: any Endpoint) async throws -> (Data, HTTPURLResponse) {
        let request = try createRequest(endpoint: endpoint)
        let (data, response) = try await session.data(request)
        let httpResponse = try validate(response: response)
        return (data, httpResponse)
    }
    
    /// Builds the request with the endpoint's URL and method, plus the access key.
    private func createRequest(endpoint: any Endpoint) throws -> URLRequest {
        guard let url = endpoint.url(host: host) else { throw NetworkError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = ["Authorization": authorization]
        return request
    }
    
    /// Maps error status codes to `NetworkError`. Unsplash signals the rate limit with a 403
    /// and `X-Ratelimit-Remaining: 0`.
    private func validate(response: URLResponse) throws -> HTTPURLResponse {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        switch httpResponse.statusCode {
        case 200..<300:
            return httpResponse
        case 401:
            throw NetworkError.unauthozied
        case 403 where httpResponse.value(forHTTPHeaderField: "X-Ratelimit-Remaining") == "0":
            throw NetworkError.rateLimited
        default:
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
    }
}
