import Foundation

struct RecentSearch: Codable, Equatable, Identifiable {
    let query: String
    var thumbnailURL: URL?

    /// Searches that only differ in letter case are the same entry.
    var id: String { query.lowercased() }
}
