//
//  PhotoGridViewModel.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import SwiftUI
import Combine

final class PhotoGridViewModel: ObservableObject {
    enum Phase: Equatable {
        case idle
        case loading
        case failure
        case finished
    }
    
    @Published private(set) var photos: [Photo] = []
    @Published private(set) var phase: Phase = .idle
    @Published var error: NetworkError?
    
    private let dataSource: PhotoGridDataSource
    private let prefetchCount = 10
    private var nextPage: Int = 1
    private var seenIDs = Set<Photo.ID>()
    private var task: Task<Void, Never>?
    
    init(dataSource: PhotoGridDataSource) {
        self.dataSource = dataSource
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
    
    private func fetchNextPage() async {
        do {
            let page = try await dataSource.loadPage(nextPage)
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
