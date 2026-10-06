//
//  PhotosRepository.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

struct PhotosRepositoryImpl: PhotosRepository {
    let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func fetchPhotos(page: Int) async throws -> [Photo] {
        let endpoint = PhotosEndpoint(page: page)
        let photos = try await client.request(endpoint: endpoint)
        return photos.map { Photo(from: $0) }
    }
    
    func searchPhotos(text: String, page: Int) async throws -> Page<Photo> {
        let endpoint = SearchPhotosEndpoint(text: text, page: page)
        let photosPage = try await client.request(endpoint: endpoint)
        return Page(
            total: photosPage.total,
            totalPages: photosPage.totalPages,
            results: photosPage.results.map { Photo(from: $0) }
        )
    }
}
