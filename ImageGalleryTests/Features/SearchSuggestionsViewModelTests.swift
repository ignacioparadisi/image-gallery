import Combine
import Foundation
import Testing
@testable import ImageGallery

@MainActor
struct SearchSuggestionsViewModelTests {
    private let recentSearches = InMemoryRecentSearchesRepository()

    private func makeViewModel(with queries: [String] = []) -> SearchSuggestionsViewModel {
        for query in queries.reversed() {
            recentSearches.record(query)
        }
        return SearchSuggestionsViewModel(repository: recentSearches)
    }

    private func recent(_ query: String) -> SearchSuggestionsViewModel.Suggestion {
        .recent(RecentSearch(query: query))
    }

    @Test func startsWithTheSavedSearches() {
        let viewModel = makeViewModel(with: ["dogs", "cats"])

        #expect(viewModel.recentSearches.map(\.query) == ["dogs", "cats"])
    }

    @Test func reloadingPicksUpNewSearches() {
        let viewModel = makeViewModel(with: ["dogs"])
        recentSearches.record("cats")

        viewModel.loadRecentSearches()

        #expect(viewModel.recentSearches.map(\.query) == ["cats", "dogs"])
    }

    @Test func reloadingUnchangedSearchesDoesNotPublish() {
        let viewModel = makeViewModel(with: ["dogs"])
        var changes = 0
        let cancellable = viewModel.objectWillChange.sink { changes += 1 }

        viewModel.loadRecentSearches()

        #expect(changes == 0)
        cancellable.cancel()
    }

    @Test(arguments: ["", "  "])
    func emptyTextSuggestsEveryRecentSearch(text: String) {
        let viewModel = makeViewModel(with: ["dogs", "cats"])

        #expect(viewModel.suggestions(for: text) == [recent("dogs"), recent("cats")])
    }

    @Test func typedTextIsSuggestedFirstFollowedByMatches() {
        let viewModel = makeViewModel(with: ["snowy mountains", "beach", "mountains"])

        #expect(viewModel.suggestions(for: " mount ") == [.search("mount"), recent("snowy mountains"), recent("mountains")])
    }

    @Test(arguments: ["dogs", "DOGS", " dogs "])
    func aRecentSearchIsNotSuggestedTwice(text: String) {
        let viewModel = makeViewModel(with: ["dogs"])

        #expect(viewModel.suggestions(for: text) == [recent("dogs")])
    }

    @Test(arguments: ["caf", "CAF", "fé"])
    func matchingIgnoresCaseAndAccents(text: String) {
        let viewModel = makeViewModel(with: ["Café", "dogs"])

        #expect(viewModel.suggestions(for: text).dropFirst() == [recent("Café")])
    }

    @Test func textWithNoMatchesOnlySuggestsSearchingIt() {
        let viewModel = makeViewModel(with: ["dogs"])

        #expect(viewModel.suggestions(for: "cats") == [.search("cats")])
    }

    @Test func noRecentSearchesAndNoTextSuggestsNothing() {
        let viewModel = makeViewModel()

        #expect(viewModel.suggestions(for: "").isEmpty)
    }
}
