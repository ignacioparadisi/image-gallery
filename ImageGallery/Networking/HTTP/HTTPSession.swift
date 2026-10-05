//
//  HTTPSession.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

nonisolated protocol HTTPSession: Sendable {
    func data(_ request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPSession {
    func data(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request)
    }
}
