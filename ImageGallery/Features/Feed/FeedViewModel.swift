//
//  FeedViewModel.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation
import Combine

class FeedViewModel: PhotoGridViewModel {
    @Published var query = ""
    @Published var selectedPhoto: Photo?
    private let repository: PhotosRepository
    
    init(repository: PhotosRepository) {
        self.repository = repository
    }
    
    override func loadPage(_ page: Int, pageSize: Int) async throws -> Page<Photo> {
        try await repository.fetchPhotos(page: page, pageSize: pageSize)
    }
}
