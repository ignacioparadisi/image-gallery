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
    
    func fetchPhotos(page: Int, pageSize: Int) async throws -> Page<Photo> {
        let endpoint = PhotosEndpoint(page: page, pageSize: pageSize)
        let response = try await client.request(endpoint: endpoint)
        let total = Int(response.headers["x-total"] ?? "") ?? 0
        return Page(
            total: total,
            totalPages: 0,
            results: response.body.map { Photo(from: $0) }
        )
    }
    
    func searchPhotos(text: String, page: Int, pageSize: Int) async throws -> Page<Photo> {
        let endpoint = SearchPhotosEndpoint(text: text, page: page, pageSize: pageSize)
        let response = try await client.request(endpoint: endpoint)
        return Page(
            total: response.body.total,
            totalPages: response.body.totalPages,
            results: response.body.results.map { Photo(from: $0) }
        )
    }
}
