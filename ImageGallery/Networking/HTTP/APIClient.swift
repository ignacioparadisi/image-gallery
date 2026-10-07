//
//  APIClient.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

nonisolated protocol APIClient: Sendable {
    func request<E: Endpoint>(endpoint: E) async throws -> HTTPResponse<E.Response>
    func data(from endpoint: any Endpoint) async throws -> (Data, HTTPURLResponse)
}
