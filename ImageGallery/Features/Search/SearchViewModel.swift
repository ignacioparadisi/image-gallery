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
    @Published var selectedPhoto: Photo?
    private let repository: PhotosRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(query: String, repository: PhotosRepository) {
        self.query = query
        self.repository = repository
        
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
        try await repository.searchPhotos(text: query, page: page, pageSize: pageSize)
    }
}
