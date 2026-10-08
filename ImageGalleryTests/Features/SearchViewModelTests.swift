import Foundation
import Testing
@testable import ImageGallery

@MainActor
struct SearchViewModelTests {
    private let recentSearches = InMemoryRecentSearchesRepository()

    @Test func searchingReplacesTheResultsAndRecordsTheQuery() async throws {
        let photos = StubPhotosRepository()
        photos.photos = [.stub(id: "mountain")]
        let viewModel = SearchViewModel(query: "mountains", repository: photos, recentSearchesRepository: recentSearches)
        viewModel.loadFirstPageIfNeeded()
        try await waitUntil { viewModel.phase != .loading }

        photos.photos = [.stub(id: "beach")]
        viewModel.search("  beach ")
        try await waitUntil { viewModel.phase != .loading }

        #expect(viewModel.query == "beach")
        #expect(viewModel.photos.map(\.id) == ["beach"])
        #expect(recentSearches.recentSearches().first?.query == "beach")
    }

    @Test(arguments: ["", "   ", "mountains"])
    func emptyOrSameQueryIsIgnored(text: String) {
        let viewModel = SearchViewModel(query: "mountains", repository: StubPhotosRepository(), recentSearchesRepository: recentSearches)

        viewModel.search(text)

        #expect(viewModel.query == "mountains")
        #expect(viewModel.phase == .idle)
        #expect(recentSearches.recentSearches().isEmpty)
    }

    @Test func aLatePageFromThePreviousQueryIsIgnored() async throws {
        let photos = PendingPhotosRepository()
        let viewModel = SearchViewModel(query: "mountains", repository: photos, recentSearchesRepository: recentSearches)
        viewModel.loadFirstPageIfNeeded()
        try await waitUntil { photos.isWaiting(for: "mountains") }

        viewModel.search("beach")
        try await waitUntil { photos.isWaiting(for: "beach") }
        photos.complete("beach", with: [.stub(id: "beach")])
        try await waitUntil { viewModel.phase != .loading }

        photos.complete("mountains", with: [.stub(id: "mountain")])
        try await Task.sleep(for: .milliseconds(50))

        #expect(viewModel.photos.map(\.id) == ["beach"])
        #expect(viewModel.phase == .finished)
    }
}
