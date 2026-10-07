//
//  NetworkError.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case unauthorized
    case rateLimited
    case httpError(statusCode: Int)
    case decodingFailed
    case offline
    case connectionFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            Localization.Network.invalidURL
        case .invalidResponse:
            Localization.Network.invalidResponse
        case .unauthorized:
            Localization.Network.unauthorized
        case .rateLimited:
            Localization.Network.rateLimited
        case .httpError(let code):
            Localization.Network.httpError(statusCode: code)
        case .decodingFailed:
            Localization.Network.decodingFailed
        case .offline:
            Localization.Network.offline
        case .connectionFailed:
            Localization.Network.connectionFailed
        }
    }
}
