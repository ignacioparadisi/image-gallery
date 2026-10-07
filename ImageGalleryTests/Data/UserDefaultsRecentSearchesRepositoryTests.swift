import Foundation
import Testing
@testable import ImageGallery

@MainActor
struct UserDefaultsRecentSearchesRepositoryTests {
    private let suiteName = "UserDefaultsRecentSearchesRepositoryTests-\(UUID().uuidString)"
    private let defaults: UserDefaults
    private let thumbnail = URL(string: "https://images.unsplash.com/cat")

    init() {
        defaults = UserDefaults(suiteName: suiteName)!
    }

    private func makeRepository() -> UserDefaultsRecentSearchesRepository {
        UserDefaultsRecentSearchesRepository(defaults: defaults)
    }

    @Test func searchesPersistAcrossInstances() {
        defer { defaults.removePersistentDomain(forName: suiteName) }
        makeRepository().record("cats")
        makeRepository().record("dogs")

        #expect(makeRepository().recentSearches().map(\.query) == ["dogs", "cats"])
    }

    @Test func thumbnailsPersist() {
        defer { defaults.removePersistentDomain(forName: suiteName) }
        makeRepository().record("cats")
        makeRepository().setThumbnailIfNeeded(thumbnail, for: "cats")

        #expect(makeRepository().recentSearches().first?.thumbnailURL == thumbnail)
    }

    @Test func storesAtMostTenSearches() {
        defer { defaults.removePersistentDomain(forName: suiteName) }
        let repository = makeRepository()
        for index in 1...12 {
            repository.record("query \(index)")
        }

        let stored = makeRepository().recentSearches()
        #expect(stored.count == 10)
        #expect(stored.first?.query == "query 12")
    }

    @Test func unreadableDataStartsAnEmptyHistory() {
        defer { defaults.removePersistentDomain(forName: suiteName) }
        defaults.set(Data("not json".utf8), forKey: "recentSearches")

        #expect(makeRepository().recentSearches().isEmpty)
    }
}
