//
//  GalleryViewModel.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation
import Combine

// @Observable is only available from iOS 17
class GalleryViewModel: ObservableObject {
    enum Content: Equatable {
        case feed
        case searchResults(PhotoGridViewModel)
        
        static func ==(lhs: Content, rhs: Content) -> Bool {
            switch (lhs, rhs) {
            case (.feed, .feed):
                return true
            case (searchResults(let lhsViewModel), .searchResults(let rhsViewModel)):
                return lhsViewModel === rhsViewModel
            default:
                return false
            }
        }
    }
    
    @Published var query = ""
//    @Published private(set) var content: Content = .feed
    
    private let repository: PhotosRepository
    let feedViewModel: PhotoGridViewModel
    @Published private(set) var searchViewModel: PhotoGridViewModel?
    private var activeQuery: String = ""
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(repository: PhotosRepository) {
        self.repository = repository
        self.feedViewModel = PhotoGridViewModel(dataSource: FeedGridDataSource(repository: self.repository))
        
        self.$query
            .dropFirst()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.search(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func search(query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedQuery.isEmpty == false else {
            searchViewModel = nil
            return
        }
        
        searchViewModel = PhotoGridViewModel(dataSource: SearchGridDataSource(repository: repository, query: trimmedQuery))
        searchViewModel?.loadFirstPageIfNeeded()
    }
    
    func fetchFeed() {
        feedViewModel.loadFirstPageIfNeeded()
    }
 }
