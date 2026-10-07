//
//  SearchViewModel.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import Foundation
import Combine

class SearchViewModel: PhotoGridViewModel {
    @Published var query = ""
    private let repository: PhotosRepository
    private let recentSearchesRepository: RecentSearchesRepository
    private var cancellables = Set<AnyCancellable>()

    init(query: String, repository: PhotosRepository, recentSearchesRepository: RecentSearchesRepository) {
        self.query = query
        self.repository = repository
        self.recentSearchesRepository = recentSearchesRepository

        super.init()

        self.$query
            .dropFirst()
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.cleanSearch()
                self?.loadFirstPageIfNeeded()
            }
            .store(in: &cancellables)
    }

    override func loadPage(_ page: Int, pageSize: Int) async throws -> Page<Photo> {
        let result = try await repository.searchPhotos(text: query, page: page, pageSize: pageSize)
        if page == 1, let thumbnailURL = result.results.first?.thumbnailURL {
            recentSearchesRepository.setThumbnailIfNeeded(thumbnailURL, for: query)
        }
        return result
    }
}
