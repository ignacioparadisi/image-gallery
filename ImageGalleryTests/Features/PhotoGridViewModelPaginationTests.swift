import Foundation
import Testing
@testable import ImageGallery

@MainActor
struct PhotoGridViewModelPaginationTests {
    @Test func keepsLoadingWhileThereAreMorePages() async throws {
        let viewModel = StubGridViewModel()
        viewModel.pages = [1: Page(total: 90, totalPages: 3, results: [.stub(id: "a")])]

        viewModel.loadFirstPageIfNeeded()
        try await waitUntil { viewModel.phase != .loading }

        #expect(viewModel.phase == .idle)
    }

    @Test func finishesAfterTheLastPage() async throws {
        let viewModel = StubGridViewModel()
        viewModel.pages = [1: Page(total: 1, totalPages: 1, results: [.stub(id: "a")])]

        viewModel.loadFirstPageIfNeeded()
        try await waitUntil { viewModel.phase != .loading }

        #expect(viewModel.phase == .finished)
    }

    @Test func finishesOnTheLastPageEvenWhenDuplicatesAreRemoved() async throws {
        let viewModel = StubGridViewModel()
        viewModel.pages = [
            1: Page(total: 3, totalPages: 2, results: [.stub(id: "a"), .stub(id: "b")]),
            2: Page(total: 3, totalPages: 2, results: [.stub(id: "b")])
        ]

        viewModel.loadFirstPageIfNeeded()
        try await waitUntil { viewModel.phase != .loading }
        viewModel.loadNextPageIfNeeded(currentPhoto: viewModel.photos[1])
        try await waitUntil { viewModel.phase != .loading }

        #expect(viewModel.photos.map(\.id) == ["a", "b"])
        #expect(viewModel.requestedPages == [1, 2])
        #expect(viewModel.phase == .finished)
    }
}
