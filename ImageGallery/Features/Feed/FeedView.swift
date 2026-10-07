//
//  FeedView.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel: FeedViewModel
    @State private var query = ""
    /// Used to dismissing the search after the search is done.
    @State private var dismissSearchTrigger: Bool = false
    
    init(viewModel: FeedViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Content(viewModel: viewModel, dismissSearchTrigger: dismissSearchTrigger)
            .navigationTitle(Localization.Feed.title)
            .softScrollEdges(.top)
            .searchable(text: $query)
            .searchSuggestions {
                if viewModel.recentSearches.isEmpty {
                    Text(Localization.Feed.noRecentSearches)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.secondary)
                        .listRowSeparator(.hidden, edges: .all)
                } else {
                    ForEach(viewModel.recentSearches) { search in
                        Button {
                            openSearch(search.query)
                        } label: {
                            RecentSearchRow(search: search)
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }
            .onSubmit(of: .search) {
                openSearch(query)
            }
            .onAppear {
                viewModel.loadFirstPageIfNeeded()
                viewModel.loadRecentSearches()
            }
            .onDisappear {
                dismissSearchTrigger.toggle()
            }
    }

    private func openSearch(_ text: String) {
        guard let query = viewModel.submitSearch(text) else { return }
        router.navigate(to: .search(query: query))
    }

    struct Content: View {
        @EnvironmentObject private var router: Router
        @Environment(\.dismissSearch) private var dismissSearch
        @ObservedObject var viewModel: FeedViewModel
        let dismissSearchTrigger: Bool

        var body: some View {
            PhotoGridView(
                viewModel: viewModel,
                hiddenPhotoID: router.presentedPhoto?.id,
                onSelect: router.showPhoto
            )
            .onChange(of: dismissSearchTrigger) { _ in
                dismissSearch()
            }
        }
    }
}
