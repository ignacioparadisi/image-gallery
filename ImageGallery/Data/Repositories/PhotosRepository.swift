//
//  PhotosRepository.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

struct PhotosRepositoryImpl: PhotosRepository {
    let client: APIClient
    
    func fetchPhotos(page: Int) async throws -> [PhotoDTO] {
        let endpoint = PhotosEndpoint(page: page)
        return try await client.request(endpoint: endpoint)
    }
    
    func searchPhotos(text: String, page: Int) async throws -> PageDTO<PhotoDTO> {
        let endpoint = SearchPhotosEndpoint(text: text, page: page)
        return try await client.request(endpoint: endpoint)
    }
}
