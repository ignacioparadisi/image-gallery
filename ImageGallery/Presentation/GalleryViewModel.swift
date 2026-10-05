//
//  GalleryViewModel.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation
import Combine

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
    @Published private(set) var photos: [PhotoDTO] = []
    
    private let repository: PhotosRepository
    private let prefetchThreshold: Int = 10
    private var seenIDs: Set<String> = []
    private var nextPage: Int = 0
    
    
    init(repository: PhotosRepository) {
        self.repository = repository
    }
    
    func loadFirstPageIfNeeded() {
        guard photos.isEmpty, case .idle = paginationState else { return }
        startLoading()
    }
    
    func loadNextPageIfNeeded(currentPhoto photo: PhotoDTO) {
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
            let page = try await repository.fetchPhotos(page: nextPage)
            let newPhotos = page.filter {  seenIDs.insert($0.id).inserted }
            photos.append(contentsOf: newPhotos)
            nextPage += 1
            paginationState = .idle
            state = photos.isEmpty ? .empty : .loaded
        } catch {
            state = .failure(error)
        }
    }
}
