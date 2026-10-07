import Foundation
import Testing
@testable import ImageGallery

@MainActor
struct RecentSearchesTests {
    private let thumbnail = URL(string: "https://images.unsplash.com/cat")

    @Test func recordAddsTheQueryToTheFront() {
        var searches = RecentSearches()
        searches.record("dogs")
        searches.record("cats")

        #expect(searches.items.map(\.query) == ["cats", "dogs"])
    }

    @Test func recordingAnExistingQueryMovesItToTheFrontAndKeepsItsThumbnail() {
        var searches = RecentSearches()
        searches.record("cats")
        searches.setThumbnailIfNeeded(thumbnail, for: "cats")
        searches.record("dogs")

        searches.record("cats")

        #expect(searches.items.map(\.query) == ["cats", "dogs"])
        #expect(searches.items.first?.thumbnailURL == thumbnail)
    }

    @Test func dropsTheLeastRecentlyUsedWhenFull() {
        var searches = RecentSearches(capacity: 3)
        searches.record("a")
        searches.record("b")
        searches.record("c")
        searches.record("a")

        searches.record("d")

        #expect(searches.items.map(\.query) == ["d", "a", "c"])
    }

    @Test func keepsAtMostTenByDefault() {
        var searches = RecentSearches()
        for index in 1...12 {
            searches.record("query \(index)")
        }

        #expect(searches.items.count == 10)
        #expect(searches.items.first?.query == "query 12")
        #expect(searches.items.last?.query == "query 3")
    }

    @Test func treatsQueriesThatOnlyDifferInCaseAsTheSame() {
        var searches = RecentSearches()
        searches.record("cats")
        searches.record("Cats")

        #expect(searches.items.map(\.query) == ["Cats"])
    }

    @Test(arguments: ["", "   ", "\n"])
    func ignoresEmptyQueries(query: String) {
        var searches = RecentSearches()
        searches.record(query)

        #expect(searches.items.isEmpty)
    }

    @Test func trimsWhitespace() {
        var searches = RecentSearches()
        searches.record("  cats  ")

        #expect(searches.items.map(\.query) == ["cats"])
    }

    @Test func settingAThumbnailDoesNotChangeTheOrder() {
        var searches = RecentSearches()
        searches.record("cats")
        searches.record("dogs")

        searches.setThumbnailIfNeeded(thumbnail, for: "cats")

        #expect(searches.items.map(\.query) == ["dogs", "cats"])
        #expect(searches.items.last?.thumbnailURL == thumbnail)
    }

    @Test func keepsTheFirstThumbnail() {
        var searches = RecentSearches()
        searches.record("cats")
        searches.setThumbnailIfNeeded(thumbnail, for: "cats")

        searches.setThumbnailIfNeeded(URL(string: "https://images.unsplash.com/other"), for: "cats")

        #expect(searches.items.first?.thumbnailURL == thumbnail)
    }

    @Test func settingAThumbnailForAnUnknownQueryDoesNothing() {
        var searches = RecentSearches()
        searches.record("cats")

        searches.setThumbnailIfNeeded(thumbnail, for: "dogs")

        #expect(searches.items == [RecentSearch(query: "cats", thumbnailURL: nil)])
    }
}
