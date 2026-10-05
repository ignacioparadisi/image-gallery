//
//  HTTPClient.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

// TODO: Move networking to a package so I don't have to use nonisolated everywhere

enum RequestError: Error {
    case invalidURL
}

protocol APIClient {
}

nonisolated struct HTTPClient: APIClient {
    private let session: HTTPSession
    private let accessKey: String
    
    init(session: HTTPSession, accessKey: String) {
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
        let (data, _) = try await session.data(request)
        return data
    }
    
    private func createRequest(endpoint: any Endpoint) throws -> URLRequest {
        guard let url = endpoint.url else { throw RequestError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = ["Authorization": "Client-ID \(accessKey)"]
        return request
    }
}
