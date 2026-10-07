//
//  PhotoGridDataSource.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import Foundation

protocol PhotoGridDataSource {
    var pageSize: Int { get }
    func loadPage(_ page: Int) async throws -> Page<Photo>
}

struct FeedGridDataSource: PhotoGridDataSource {
    let pageSize: Int
    let repository: PhotosRepository
    
    func loadPage(_ page: Int) async throws -> Page<Photo> {
        try await repository.fetchPhotos(page: page, pageSize: pageSize)
    }
}

struct SearchGridDataSource: PhotoGridDataSource {
    let pageSize: Int
    let query: String
    let repository: PhotosRepository
    
    func loadPage(_ page: Int) async throws -> Page<Photo> {
        try await repository.searchPhotos(text: query, page: page, pageSize: pageSize)
    }
}
