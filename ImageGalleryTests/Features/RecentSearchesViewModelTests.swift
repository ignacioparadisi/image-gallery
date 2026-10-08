import Foundation
import Testing
@testable import ImageGallery

@MainActor
struct FeedViewModelRecentSearchesTests {
    private let recentSearches = InMemoryRecentSearchesRepository()

    private func makeViewModel() -> FeedViewModel {
        FeedViewModel(repository: StubPhotosRepository(), recentSearchesRepository: recentSearches)
    }

    @Test func submittingRecordsTheTrimmedQueryAndReturnsIt() {
        let viewModel = makeViewModel()

        let query = viewModel.submitSearch("  cats ")

        #expect(query == "cats")
        #expect(recentSearches.recentSearches().map(\.query) == ["cats"])
    }

    @Test func submittingEmptyTextDoesNothing() {
        let viewModel = makeViewModel()

        #expect(viewModel.submitSearch("   ") == nil)
        #expect(recentSearches.recentSearches().isEmpty)
    }
}

@MainActor
struct SearchViewModelRecentSearchesTests {
    @Test func savesTheFirstResultsThumbnailForTheQuery() async throws {
        let recentSearches = InMemoryRecentSearchesRepository()
        recentSearches.record("cats")
        let photos = StubPhotosRepository()
        photos.photos = [.stub(id: "first"), .stub(id: "second")]
        let viewModel = SearchViewModel(query: "cats", repository: photos, recentSearchesRepository: recentSearches)

        viewModel.loadFirstPageIfNeeded()
        try await waitUntil { !viewModel.photos.isEmpty }

        #expect(recentSearches.recentSearches().first?.thumbnailURL == Photo.stub(id: "first").thumbnailURL)
    }

    @Test func keepsTheThumbnailFromTheFirstTimeTheQueryWasSearched() async throws {
        let recentSearches = InMemoryRecentSearchesRepository()
        recentSearches.record("cats")
        recentSearches.setThumbnailIfNeeded(Photo.stub(id: "original").thumbnailURL, for: "cats")
        let photos = StubPhotosRepository()
        photos.photos = [.stub(id: "newer")]
        let viewModel = SearchViewModel(query: "cats", repository: photos, recentSearchesRepository: recentSearches)

        viewModel.loadFirstPageIfNeeded()
        try await waitUntil { !viewModel.photos.isEmpty }

        #expect(recentSearches.recentSearches().first?.thumbnailURL == Photo.stub(id: "original").thumbnailURL)
    }
}
