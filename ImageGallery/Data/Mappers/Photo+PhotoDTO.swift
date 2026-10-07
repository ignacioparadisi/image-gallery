//
//  Photo+PhotoDTO.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import Foundation

extension Photo {
    init(from dto: PhotoDTO) {
        self.id = dto.id
        self.width = dto.width
        self.height = dto.height
        self.description = dto.altDescription ?? dto.description
        self.blurHash = dto.blurHash
        self.thumbnailURL = URL(string: dto.urls.small ?? "")
        self.url = URL(string: dto.urls.regular ?? "")
    }
}
