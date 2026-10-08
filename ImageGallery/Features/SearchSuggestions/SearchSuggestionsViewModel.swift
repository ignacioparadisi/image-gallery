//
//  SearchSuggestionsViewModel.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/7/26.
//

import Foundation
import Combine

class SearchSuggestionsViewModel: ObservableObject {
    enum Suggestion: Identifiable, Equatable {
        /// Searches for what the user typed.
        case search(String)
        case recent(RecentSearch)

        var id: String {
            switch self {
            case .search(let query): "search-\(query)"
            case .recent(let search): "recent-\(search.id)"
            }
        }
    }

    @Published private(set) var recentSearches: [RecentSearch] = []
    private let repository: RecentSearchesRepository

    init(repository: RecentSearchesRepository) {
        self.repository = repository
        loadRecentSearches()
    }

    func loadRecentSearches() {
        let searches = repository.recentSearches()
        guard searches != recentSearches else { return }
        recentSearches = searches
    }

    func suggestions(for text: String) -> [Suggestion] {
        guard let query = text.searchQuery else {
            return recentSearches.map(Suggestion.recent)
        }
        let matches = recentSearches.filter { $0.query.localizedStandardContains(query) }
        let isRecentSearch = recentSearches.contains { $0.id == query.lowercased() }
        return (isRecentSearch ? [] : [.search(query)]) + matches.map(Suggestion.recent)
    }
}
