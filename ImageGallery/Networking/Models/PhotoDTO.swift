//
//  PhotoDTO.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

nonisolated struct PhotoDTO: Decodable, Sendable, Identifiable {
    let id: String
    let width: Int
    let height: Int
    let color: String?
    let altDescription: String?
    let description: String?
    let blurHash: String?
    let urls: URLs
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case color
        case altDescription = "alt_description"
        case description
        case blurHash
        case urls
    }
}

extension PhotoDTO {
    struct URLs: Decodable, Sendable {
        let raw: String?
        let full: String?
        let regular: String?
        let small: String?
        let thumb: String?
        let smallS3: String?
        
        enum CodingKeys: String, CodingKey {
            case raw
            case full
            case regular
            case small
            case thumb
            case smallS3 = "small_s3"
        }
    }
}
