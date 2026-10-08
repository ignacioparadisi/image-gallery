import Foundation

extension Localization {
    enum SearchSuggestions {
        static let noRecentSearches = String(
            localized: "Localization.SearchSuggestions.noRecentSearches",
            defaultValue: "No Recent Searches"
        )

        static func searchFor(_ text: String) -> String {
            String(
                localized: "Localization.SearchSuggestions.searchFor",
                defaultValue: "Search for \"\(text)\""
            )
        }
    }
}
