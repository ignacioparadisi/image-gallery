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
    /// Used to dismissing the search after the search is done.
    @State private var dismissSearchTrigger: Bool = false
    
    init(viewModel: FeedViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Content(viewModel: viewModel, dismissSearchTrigger: dismissSearchTrigger)
            .navigationTitle("Feed")
            .softScrollEdges(.top)
            .searchable(text: $viewModel.query)
            .searchSuggestions {
                Text("No Recent Searches")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.secondary)
                    .listRowSeparator(.hidden, edges: .all)
            }
            .onSubmit(of: .search) {
                router.navigate(to: .search(query: viewModel.query))
            }
            .onAppear {
                viewModel.loadFirstPageIfNeeded()
            }
            .onDisappear {
                dismissSearchTrigger.toggle()
            }
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
