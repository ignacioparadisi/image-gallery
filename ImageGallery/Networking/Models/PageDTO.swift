//
//  PageDTO.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

nonisolated struct PageDTO<D: Decodable>: Decodable {
    let total: Int
    let totalPages: Int
    let results: [D]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}
