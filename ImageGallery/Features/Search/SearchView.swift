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
    @State private var query: String

    init(viewModel: SearchViewModel, searchSuggestionsViewModel: SearchSuggestionsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._searchSuggestionsViewModel = StateObject(wrappedValue: searchSuggestionsViewModel)
        self._query = State(initialValue: viewModel.query)
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
            text: $query,
            viewModel: searchSuggestionsViewModel,
            submittedQuery: viewModel.query,
            onSubmit: viewModel.search
        )
        .onAppear {
            viewModel.loadFirstPageIfNeeded()
        }
    }
}
