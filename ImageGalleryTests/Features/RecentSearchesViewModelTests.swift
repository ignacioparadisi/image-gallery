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
        #expect(viewModel.recentSearches.map(\.query) == ["cats"])
        #expect(recentSearches.recentSearches().map(\.query) == ["cats"])
    }

    @Test func submittingEmptyTextDoesNothing() {
        let viewModel = makeViewModel()

        #expect(viewModel.submitSearch("   ") == nil)
        #expect(recentSearches.recentSearches().isEmpty)
    }

    @Test func loadingReadsTheSavedSearches() {
        recentSearches.record("dogs")
        let viewModel = makeViewModel()

        viewModel.loadRecentSearches()

        #expect(viewModel.recentSearches.map(\.query) == ["dogs"])
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
        for _ in 0..<50 where viewModel.photos.isEmpty {
            try await Task.sleep(for: .milliseconds(10))
        }

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
        for _ in 0..<50 where viewModel.photos.isEmpty {
            try await Task.sleep(for: .milliseconds(10))
        }

        #expect(recentSearches.recentSearches().first?.thumbnailURL == Photo.stub(id: "original").thumbnailURL)
    }
}
