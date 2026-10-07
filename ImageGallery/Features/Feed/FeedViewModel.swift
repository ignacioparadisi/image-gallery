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
    @Published private(set) var recentSearches: [RecentSearch] = []
    private let repository: PhotosRepository
    private let recentSearchesRepository: RecentSearchesRepository

    init(repository: PhotosRepository, recentSearchesRepository: RecentSearchesRepository) {
        self.repository = repository
        self.recentSearchesRepository = recentSearchesRepository
    }

    override func loadPage(_ page: Int, pageSize: Int) async throws -> Page<Photo> {
        try await repository.fetchPhotos(page: page, pageSize: pageSize)
    }

    func loadRecentSearches() {
        recentSearches = recentSearchesRepository.recentSearches()
    }

    /// Saves the search and returns the query to open, or `nil` if the text is empty.
    func submitSearch(_ text: String) -> String? {
        let query = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return nil }
        recentSearchesRepository.record(query)
        loadRecentSearches()
        return query
    }
}
