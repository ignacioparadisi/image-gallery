//
//  NetworkError.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case unauthozied
    case rateLimited
    case httpError(statusCode: Int)
    case decodingFailed
}
