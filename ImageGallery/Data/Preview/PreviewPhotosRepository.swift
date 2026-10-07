//
//  PreviewPhotosRepository.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

#if DEBUG
struct PreviewPhotosRepository: PhotosRepository {
    func fetchPhotos(page: Int, pageSize: Int) async throws -> Page<Photo> {
        return Page(
            total: 0,
            totalPages: 0,
            results: PhotoDTO.previews.map { Photo(from: $0) }
        )
    }
    
    func searchPhotos(text: String, page: Int, pageSize: Int) async throws -> Page<Photo> {
        let page = PageDTO(total: 20, totalPages: 20, results: PhotoDTO.previews)
        return Page(
            total: page.total,
            totalPages: page.totalPages,
            results: page.results.map { Photo(from: $0) }
        )
    }
}
#endif
