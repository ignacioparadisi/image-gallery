//
//  View+SearchSuggestions.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/7/26.
//

import SwiftUI

extension View {
    /// Adds a search field that suggests recent searches.
    /// `submittedQuery` is the search the screen is showing. The field goes back to it when searching ends.
    func searchWithSuggestions(
        viewModel: SearchSuggestionsViewModel,
        submittedQuery: String? = nil,
        onSubmit: @escaping (String) -> Void
    ) -> some View {
        modifier(SearchWithSuggestionsModifier(
            viewModel: viewModel,
            submittedQuery: submittedQuery,
            onSubmit: onSubmit
        ))
    }
}

private struct SearchWithSuggestionsModifier: ViewModifier {
    let viewModel: SearchSuggestionsViewModel
    let submittedQuery: String?
    let onSubmit: (String) -> Void
    @State private var text: String
    @State private var submitCount = 0

    init(viewModel: SearchSuggestionsViewModel, submittedQuery: String?, onSubmit: @escaping (String) -> Void) {
        self.viewModel = viewModel
        self.submittedQuery = submittedQuery
        self.onSubmit = onSubmit
        self._text = State(initialValue: submittedQuery ?? "")
    }

    func body(content: Content) -> some View {
        content
            .background(SearchFieldObserver(
                text: $text,
                viewModel: viewModel,
                submittedQuery: submittedQuery,
                submitCount: submitCount
            ))
            .searchable(text: $text)
            .searchSuggestions {
                SearchSuggestionsView(viewModel: viewModel, text: text == submittedQuery ? "" : text)
            }
            .onSubmit(of: .search) {
                onSubmit(text)
                submitCount += 1
            }
    }
}

/// `isSearching` and `dismissSearch` can only be read from inside the searchable view.
private struct SearchFieldObserver: View {
    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch
    @Binding var text: String
    let viewModel: SearchSuggestionsViewModel
    let submittedQuery: String?
    let submitCount: Int

    var body: some View {
        Color.clear
            .onChange(of: submitCount) { _ in
                if submittedQuery != nil {
                    dismissSearch()
                }
            }
            .onDisappear {
                dismissSearch()
            }
            .onChange(of: isSearching) { searching in
                if searching {
                    viewModel.loadRecentSearches()
                } else if let submittedQuery {
                    // iOS clears the field after this runs, so restore it on the next run loop.
                    DispatchQueue.main.async {
                        text = submittedQuery
                    }
                }
            }
    }
}
