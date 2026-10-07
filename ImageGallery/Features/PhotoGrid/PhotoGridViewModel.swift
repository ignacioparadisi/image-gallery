//
//  PhotoGridViewModel.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import SwiftUI
import Combine

class PhotoGridViewModel: ObservableObject {
    enum PhaseStyle {
        case fullScreen
        case footer
    }
    enum Phase: Equatable {
        case idle
        case loading
        case failure(NetworkError)
        case empty
        case finished
    }
    
    @Published private(set) var photos: [Photo] = []
    @Published private(set) var phase: Phase = .idle
    @Published private(set) var phaseStyle: PhaseStyle = .fullScreen
    
    private let prefetchCount = 10
    private var nextPage: Int = 1
    private var seenIDs = Set<Photo.ID>()
    private var task: Task<Void, Never>?
    let pageSize: Int = 30
    
    var isLoading: Bool {
        phase == .loading && photos.isEmpty
    }
    
    func cleanSearch() {
        photos.removeAll()
    }
    
    func loadFirstPageIfNeeded() {
        guard photos.isEmpty, phase == .idle else { return }
        phase = .loading
        phaseStyle = photos.isEmpty ? .fullScreen : .footer
        task = Task { await fetchNextPage() }
    }
    
    func loadNextPageIfNeeded(currentPhoto photo: Photo) {
        guard phase == .idle,
              photos.suffix(prefetchCount).contains(where: { $0.id == photo.id }) else {
            return
        }
        phase = .loading
        phaseStyle = photos.isEmpty ? .fullScreen : .footer
        task = Task { await fetchNextPage() }
    }
    
    func retry() {
        guard case .failure = phase else { return }
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
            phaseStyle = photos.isEmpty ? .fullScreen : .footer
            if photos.isEmpty {
                phase = .empty
            } else {
                phase = nextPage > page.totalPages ? .finished : .idle
            }
        } catch {
            if let error = error as? NetworkError {
                phaseStyle = photos.isEmpty ? .fullScreen : .footer
                phase = .failure(error)
            } else {
                phase = Task.isCancelled ? .idle : .failure(.invalidResponse)
            }
        }
    }
    
    func cancel() {
        task?.cancel()
    }
    
}
