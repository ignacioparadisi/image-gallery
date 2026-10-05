//
//  HTTPClient.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

// TODO: Move networking to a package so I don't have to use nonisolated everywhere

struct HTTPClient: APIClient {
    private let session: HTTPSession
    private let accessKey: String
    
    init(session: HTTPSession = URLSession.shared, accessKey: String) {
        self.session = session
        self.accessKey = accessKey
    }
    
    @concurrent
    func request<E: Endpoint>(endpoint: E) async throws -> E.Response {
        let data = try await data(from: endpoint)
        return try JSONDecoder().decode(E.Response.self, from: data)
    }
    
    func data(from endpoint: any Endpoint) async throws -> Data {
        let request = try createRequest(endpoint: endpoint)
        let (data, response) = try await session.data(request)
        try validate(response: response)
        return data
    }
    
    private func createRequest(endpoint: any Endpoint) throws -> URLRequest {
        guard let url = endpoint.url else { throw NetworkError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = ["Authorization": "Client-ID \(accessKey)"]
        return request
    }
    
    private func validate(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        switch httpResponse.statusCode {
        case 200..<300:
            return
        case 401:
            throw NetworkError.unauthozied
        case 403 where httpResponse.value(forHTTPHeaderField: "X-Ratelimit-Remaining") == "0":
            throw NetworkError.rateLimited
        default:
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
    }
}
