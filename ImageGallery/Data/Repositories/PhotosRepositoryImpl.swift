//
//  PhotosRepositoryImpl.swift
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
        let photos = response.body.map { Photo(from: $0) }
        guard let total = response.header("X-Total").flatMap(Int.init) else {
            // This is done to let the view load more photos when there is no page information
            return Page(
                total: photos.count,
                totalPages: photos.count < pageSize ? page : page + 1,
                results: photos
            )
        }
        return Page(
            total: total,
            totalPages: (total + pageSize - 1) / pageSize,
            results: photos
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
