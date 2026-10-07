import Foundation

protocol RecentSearchesRepository {
    func recentSearches() -> [RecentSearch]
    func record(_ query: String)
    func setThumbnailIfNeeded(_ url: URL?, for query: String)
}
