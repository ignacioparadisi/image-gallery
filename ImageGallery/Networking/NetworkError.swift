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
            "The URL is not valid"
        case .invalidResponse:
            "The response is not valid"
        case .unauthorized:
            "Unauthorized"
        case .rateLimited:
            "You've reached the request limit rate for this hour"
        case .httpError(let code):
            "Network error with code \(code)"
        case .decodingFailed:
            "There was an error reading the response"
        case .offline:
            "You're offline"
        case .connectionFailed:
            "Couldn't connect to Unsplash"
        }
    }
}
