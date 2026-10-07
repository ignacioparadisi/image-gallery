//
//  HTTPClient.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation
import OSLog

nonisolated struct HTTPResponse<Body: Decodable> {
    typealias Headers = [String: String]
    let headers: Headers
    let statusCode: Int
    let body: Body
    
    init(body: Body, response: HTTPURLResponse) {
        self.body = body
        self.statusCode = response.statusCode
        var headers: [String: String] = [:]
        
        for (key, value) in response.allHeaderFields {
            if let key = key as? String, let value = value as? String {
                headers[key] = value
            }
        }
        self.headers = headers
    }
}

// TODO: Move networking to a package so I don't have to use nonisolated everywhere

struct HTTPClient: APIClient {
    private let logger = Logger(subsystem: "HTTPClient", category: "Network")
    private let session: HTTPSession
    private let accessKey: String
    
    init(session: HTTPSession = URLSession.shared, accessKey: String) {
        self.session = session
        self.accessKey = accessKey
    }
    
    @concurrent
    func request<E: Endpoint>(endpoint: E) async throws -> HTTPResponse<E.Response> {
        logger.debug("Requesting from \(endpoint.url?.absoluteString ?? "")")
        let (data, response) = try await data(from: endpoint)
        let body = try JSONDecoder().decode(E.Response.self, from: data)
        return HTTPResponse(body: body, response: response)
    }
    
    func data(from endpoint: any Endpoint) async throws -> (Data, HTTPURLResponse) {
        let request = try createRequest(endpoint: endpoint)
        let (data, response) = try await session.data(request)
        let httpResponse = try validate(response: response)
        return (data, httpResponse)
    }
    
    private func createRequest(endpoint: any Endpoint) throws -> URLRequest {
        guard let url = endpoint.url else { throw NetworkError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = ["Authorization": "Client-ID \(accessKey)"]
        return request
    }
    
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
