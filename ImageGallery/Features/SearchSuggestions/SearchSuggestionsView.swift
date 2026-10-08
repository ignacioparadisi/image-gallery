import SwiftUI

struct SearchSuggestionsView: View {
    @ObservedObject var viewModel: SearchSuggestionsViewModel
    let text: String

    var body: some View {
        let suggestions = viewModel.suggestions(for: text)
        Group {
            if suggestions.isEmpty {
                Text(Localization.SearchSuggestions.noRecentSearches)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.secondary)
                    .listRowSeparator(.hidden, edges: .all)
            } else {
                ForEach(suggestions) { suggestion in
                    switch suggestion {
                    case .search(let query):
                        Label(Localization.SearchSuggestions.searchFor(query), systemImage: "magnifyingglass")
                            .searchCompletion(query)
                    case .recent(let search):
                        RecentSearchRow(search: search)
                            .searchCompletion(search.query)
                    }
                }
            }
        }
        .tint(.primary)
    }
}
