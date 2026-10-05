//
//  PreviewPhotosRepository.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

#if DEBUG
struct PreviewPhotosRepository: PhotosRepository {
    func fetchPhotos(page: Int) async throws -> [PhotoDTO] {
        return PhotoDTO.previews
    }
    
    func searchPhotos(text: String, page: Int) async throws -> PageDTO<PhotoDTO> {
        return PageDTO(total: 20, totalPages: 20, results: PhotoDTO.previews)
    }
}
#endif
