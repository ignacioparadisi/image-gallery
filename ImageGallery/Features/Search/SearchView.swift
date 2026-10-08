//
//  SearchView.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel: SearchViewModel
    @StateObject private var searchSuggestionsViewModel: SearchSuggestionsViewModel

    /// The view models are autoclosures so they're only created once, not every time the parent redraws.
    init(
        viewModel: @autoclosure @escaping () -> SearchViewModel,
        searchSuggestionsViewModel: @autoclosure @escaping () -> SearchSuggestionsViewModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel())
        self._searchSuggestionsViewModel = StateObject(wrappedValue: searchSuggestionsViewModel())
    }

    var body: some View {
        PhotoGridView(
            viewModel: viewModel,
            hiddenPhotoID: router.presentedPhoto?.id,
            onSelect: router.showPhoto
        )
        .equatable()
        .navigationTitle(viewModel.query)
        .navigationBarTitleDisplayMode(.inline)
        .softScrollEdges(.top)
        .searchWithSuggestions(
            viewModel: searchSuggestionsViewModel,
            submittedQuery: viewModel.query,
            onSubmit: viewModel.search
        )
        .onAppear {
            viewModel.loadFirstPageIfNeeded()
        }
    }
}
