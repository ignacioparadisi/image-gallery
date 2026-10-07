import Foundation

/// Stores recent searches as JSON in `UserDefaults`.
final class UserDefaultsRecentSearchesRepository: RecentSearchesRepository {
    private let defaults: UserDefaults
    private let key: String
    private let capacity: Int

    init(
        defaults: UserDefaults = .standard,
        key: String = "recentSearches",
        capacity: Int = RecentSearches.defaultCapacity
    ) {
        self.defaults = defaults
        self.key = key
        self.capacity = capacity
    }

    func recentSearches() -> [RecentSearch] {
        load().items
    }

    func record(_ query: String) {
        var searches = load()
        searches.record(query)
        save(searches)
    }

    func setThumbnailIfNeeded(_ url: URL?, for query: String) {
        var searches = load()
        searches.setThumbnailIfNeeded(url, for: query)
        save(searches)
    }

    /// Unreadable data, for example after changing `RecentSearch`, starts an empty history.
    private func load() -> RecentSearches {
        guard let data = defaults.data(forKey: key),
              let items = try? JSONDecoder().decode([RecentSearch].self, from: data) else {
            return RecentSearches(capacity: capacity)
        }
        return RecentSearches(items: items, capacity: capacity)
    }

    private func save(_ searches: RecentSearches) {
        guard let data = try? JSONEncoder().encode(searches.items) else { return }
        defaults.set(data, forKey: key)
    }
}
