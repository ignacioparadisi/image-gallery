//
//  PhotoGridViewModel.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import SwiftUI
import Combine

class PhotoGridViewModel: ObservableObject {
    enum Phase: Equatable {
        case idle
        case loading
        case failure
        case finished
    }
    
    @Published private(set) var photos: [Photo] = []
    @Published private(set) var phase: Phase = .idle
    @Published var error: NetworkError?
    
    private let prefetchCount = 10
    private var nextPage: Int = 1
    private var seenIDs = Set<Photo.ID>()
    private var task: Task<Void, Never>?
    let pageSize: Int = 30
    
    func cleanSearch() {
        photos.removeAll()
    }
    
    func loadFirstPageIfNeeded() {
        guard photos.isEmpty, phase == .idle else { return }
        phase = .loading
        task = Task { await fetchNextPage() }
    }
    
    func loadNextPageIfNeeded(currentPhoto photo: Photo) {
        guard phase == .idle,
              photos.suffix(prefetchCount).contains(where: { $0.id == photo.id }) else {
            return
        }
        phase = .loading
        task = Task { await fetchNextPage() }
    }
    
    func loadPage(_ page: Int, pageSize: Int) async throws -> Page<Photo> {
        fatalError("\(Self.self) must override loadPage(_:)")
    }
    
    private func fetchNextPage() async {
        do {
            let page = try await loadPage(nextPage, pageSize: pageSize)
            try Task.checkCancellation()
            photos += page.results.filter { seenIDs.insert($0.id).inserted }
            nextPage += 1
            phase = photos.count < page.total ? .idle : .finished
        } catch is NetworkError {
            phase = .idle
            self.error = error
        } catch {
            phase = Task.isCancelled ? .idle : .failure
        }
    }
    
    func cancel() {
        task?.cancel()
    }
    
}
