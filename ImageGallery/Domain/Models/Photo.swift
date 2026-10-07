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
    let description: String?
    let blurHash: String?
    let thumbnailURL: URL?
    let url: URL?
}
