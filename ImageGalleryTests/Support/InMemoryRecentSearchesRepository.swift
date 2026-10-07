import Foundation
@testable import ImageGallery

@MainActor
final class InMemoryRecentSearchesRepository: RecentSearchesRepository {
    private(set) var searches = RecentSearches()

    func recentSearches() -> [RecentSearch] {
        searches.items
    }

    func record(_ query: String) {
        searches.record(query)
    }

    func setThumbnailIfNeeded(_ url: URL?, for query: String) {
        searches.setThumbnailIfNeeded(url, for: query)
    }
}
