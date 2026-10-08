import Foundation

/// Searches ordered from most to least recently used. When full, the least recently used is dropped.
struct RecentSearches: Equatable {
    static let defaultCapacity = 10

    let capacity: Int
    private(set) var items: [RecentSearch]

    init(items: [RecentSearch] = [], capacity: Int = Self.defaultCapacity) {
        self.capacity = capacity
        self.items = Array(items.prefix(capacity))
    }

    /// Moves the query to the front, keeping its thumbnail if it was already saved.
    mutating func record(_ query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedQuery.isEmpty == false else { return }

        let id = trimmedQuery.lowercased()
        let thumbnailURL = items.first { $0.id == id }?.thumbnailURL
        items.removeAll { $0.id == id }
        items.insert(RecentSearch(query: trimmedQuery, thumbnailURL: thumbnailURL), at: 0)

        if items.count > capacity {
            items.removeLast(items.count - capacity)
        }
    }

    mutating func setThumbnailIfNeeded(_ url: URL?, for query: String) {
        let id = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard id.isEmpty == false,
              let index = items.firstIndex(where: { $0.id == id }),
              items[index].thumbnailURL == nil else { return }
        items[index].thumbnailURL = url
    }
}
