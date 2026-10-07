//
//  Photo.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import Foundation

struct Photo: Identifiable, Hashable, Equatable {
    let id: String
    let width: Int
    let height: Int
    let color: String?
    let altDescription: String?
    let description: String?
    let blurHash: String?
    let urls: URLs
    
    struct URLs: Hashable, Equatable {
        let raw: String?
        let full: String?
        let regular: String?
        let small: String?
        let thumb: String?
        let smallS3: String?
    }
}

extension Photo {
    init(from dto: PhotoDTO) {
        self.id = dto.id
        self.width = dto.width
        self.height = dto.height
        self.color = dto.color
        self.altDescription = dto.altDescription
        self.description = dto.description
        self.blurHash = dto.blurHash
        self.urls = URLs(
            raw: dto.urls.raw,
            full: dto.urls.full,
            regular: dto.urls.regular,
            small: dto.urls.small,
            thumb: dto.urls.thumb,
            smallS3: dto.urls.smallS3
        )
    }
}

