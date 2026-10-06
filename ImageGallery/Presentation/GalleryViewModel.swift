//
//  GalleryViewModel.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation
import Combine

struct PagedPhotos {
    private(set) var photos: [Photo] = []
    private(set) var nextPage = 1
    private(set) var isFinished: Bool = false
    private var seenIDs: Set<String> = []
    
    mutating func append(_ page: [Photo], isLastPage: Bool) {
        photos += page.filter { seenIDs.insert($0.id).inserted }
        nextPage += 1
        isFinished = isLastPage
    }
}

// @Observable is only available from iOS 17
final class GalleryViewModel: ObservableObject {
    enum ViewState {
        case loading
        case loaded
        case empty
        case failure(Error)
    }
    
    enum PaginationState {
        case idle
        case loading
        case loaded
        case failure(Error)
    }
    
    @Published private(set) var state: ViewState = .loading
    @Published private(set) var paginationState: PaginationState = .idle
    @Published private(set) var feed = PagedPhotos()
    @Published private(set) var searchResults = PagedPhotos()
    @Published var searchText: String = "" {
        didSet {
            searchTextSubject.send(searchText)
        }
    }
    
    private var searchTask: Task<Void, Never>?
    private var searchTextSubject = CurrentValueSubject<String, Never>("")
    private var cancellables = Set<AnyCancellable>()
    
    private let repository: PhotosRepository
    private let prefetchThreshold: Int = 10
    private var seenIDs: Set<String> = []
    private var nextPage: Int = 1
    
    var isSearching: Bool {
        searchTextSubject.value.isEmpty == false
    }
    var photos: [Photo] {
        isSearching ? searchResults.photos : feed.photos
    }
    
    init(repository: PhotosRepository) {
        self.repository = repository
        
        searchTextSubject
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.search(query)
            }
            .store(in: &cancellables)
    }
    
    func loadFirstPageIfNeeded() {
        guard photos.isEmpty, case .idle = paginationState else { return }
        startLoading()
    }
    
    func loadNextPageIfNeeded(currentPhoto photo: Photo) {
        guard case .idle = paginationState, photos.suffix(prefetchThreshold).contains(where: { $0.id == photo.id }) else {
            return
        }
        startLoading()
    }
    
    private func startLoading() {
        paginationState = .loading
        Task { await loadNextPage() }
    }
    
    private func loadNextPage() async {
        do {
            let page = try await repository.fetchPhotos(page: feed.nextPage)
            feed.append(page, isLastPage: false)
            paginationState = .idle
            state = feed.photos.isEmpty ? .empty : .loaded
        } catch NetworkError.rateLimited {
            // TODO: Show alert when limit reached
        } catch {
            state = .failure(error)
        }
    }
    
    private func search(_ text: String) {
        searchTask?.cancel()
        searchResults = PagedPhotos()
        guard text.isEmpty == false else { return }
        searchTask = Task { await loadNextSearchPage(with: text) }
    }
    
    private func loadNextSearchPage(with text: String) async  {
        do {
            let page = try await repository.searchPhotos(text: text, page: searchResults.nextPage)
            guard text == searchText else { return }
            searchResults.append(page.results, isLastPage: searchResults.nextPage >= page.totalPages)
        } catch {
            if Task.isCancelled { return }
        }
    }
}
