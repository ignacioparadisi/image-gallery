//
//  PhotosRepository.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

protocol PhotosRepository {
    func fetchPhotos(page: Int) async throws -> [Photo]
    func searchPhotos(text: String, page: Int) async throws -> Page<Photo>
}
