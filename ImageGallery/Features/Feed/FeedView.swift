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
    @StateObject private var searchSuggestionsViewModel: SearchSuggestionsViewModel
    @State private var query = ""

    init(viewModel: FeedViewModel, searchSuggestionsViewModel: SearchSuggestionsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._searchSuggestionsViewModel = StateObject(wrappedValue: searchSuggestionsViewModel)
    }

    var body: some View {
        Content(viewModel: viewModel)
            .navigationTitle(Localization.Feed.title)
            .softScrollEdges(.top)
            .searchWithSuggestions(text: $query, viewModel: searchSuggestionsViewModel, onSubmit: openSearch)
            .onAppear {
                viewModel.loadFirstPageIfNeeded()
            }
    }

    private func openSearch(_ text: String) {
        guard let query = viewModel.submitSearch(text) else { return }
        router.navigate(to: .search(query: query))
    }

    struct Content: View {
        @EnvironmentObject private var router: Router
        @ObservedObject var viewModel: FeedViewModel

        var body: some View {
            PhotoGridView(
                viewModel: viewModel,
                hiddenPhotoID: router.presentedPhoto?.id,
                onSelect: router.showPhoto
            )
            .equatable()
        }
    }
}
