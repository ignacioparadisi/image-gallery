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
    case unauthozied
    case rateLimited
    case httpError(statusCode: Int)
    case decodingFailed
    
    var recoverySuggestion: String? {
        "Hola"
    }
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "The URL is not valid"
        case .invalidResponse:
            "The responde is not valid"
        case .unauthozied:
            "Unauthorized"
        case .rateLimited:
            "You've reached the request limit rate for this hour"
        case .httpError(let code):
            "Network error with code \(code)"
        case .decodingFailed:
            "There was an error reading the response"
        }
    }
}
