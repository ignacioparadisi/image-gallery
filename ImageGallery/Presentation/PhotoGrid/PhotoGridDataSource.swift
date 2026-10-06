//
//  PhotoGridDataSource.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import Foundation

protocol PhotoGridDataSource {
    func loadPage(_ page: Int) async throws -> Page<Photo>
}

struct FeedGridDataSource: PhotoGridDataSource {
    let repository: PhotosRepository
    
    func loadPage(_ page: Int) async throws -> Page<Photo> {
        try await repository.fetchPhotos(page: page)
    }
}

struct SearchGridDataSource: PhotoGridDataSource {
    let repository: PhotosRepository
    let query: String
    
    func loadPage(_ page: Int) async throws -> Page<Photo> {
        try await repository.searchPhotos(text: query, page: page)
    }
}
