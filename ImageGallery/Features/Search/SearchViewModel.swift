//
//  SearchViewModel.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import Foundation
import Combine

class SearchViewModel: PhotoGridViewModel {
    @Published private(set) var query: String
    private let repository: PhotosRepository
    private let recentSearchesRepository: RecentSearchesRepository

    init(query: String, repository: PhotosRepository, recentSearchesRepository: RecentSearchesRepository) {
        self.query = query
        self.repository = repository
        self.recentSearchesRepository = recentSearchesRepository
    }

    override func loadPage(_ page: Int, pageSize: Int) async throws -> Page<Photo> {
        let query = query
        let result = try await repository.searchPhotos(text: query, page: page, pageSize: pageSize)
        if page == 1, let thumbnailURL = result.results.first?.thumbnailURL {
            recentSearchesRepository.setThumbnailIfNeeded(thumbnailURL, for: query)
        }
        return result
    }

    func search(_ text: String) {
        guard let query = text.searchQuery, query != self.query else { return }
        recentSearchesRepository.record(query)
        self.query = query
        reload()
    }
}
