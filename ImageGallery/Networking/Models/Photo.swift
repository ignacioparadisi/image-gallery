//
//  Photo.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

struct Photo: Decodable, Sendable, Identifiable, Equatable {
    let id: String
    let width: Int
    let height: Int
    let color: String?
    let altDescription: String?
    let description: String?
    let blurHash: String?
    let urls: PhotosURLs
    
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
    
    static func ==(rhs: Photo, lhs: Photo) -> Bool {
        return rhs.id == lhs.id
    }
}
