//
//  FeedView.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import SwiftUI

struct FeedView: View {
    @Environment(\.router) private var router
    @StateObject private var viewModel: FeedViewModel
    @State private var dismissSearchTrigger: Bool = false
    
    init(viewModel: FeedViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Content(viewModel: viewModel, dismissSearchTrigger: dismissSearchTrigger)
            .navigationTitle("Feed")
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
        @Environment(\.router) private var router
        @Environment(\.dismissSearch) private var dismissSearch
        @ObservedObject var viewModel: FeedViewModel
        let dismissSearchTrigger: Bool
        
        var photoBinding: Binding<Photo?> {
            Binding {
                router.selectedPhoto
            } set: {
                router.selectedPhoto = $0
            }
        }
        
        var body: some View {
            PhotoGridView(photos: viewModel.photos, selection: photoBinding) {
                viewModel.loadNextPageIfNeeded(currentPhoto: $0)
            }
            .onChange(of: dismissSearchTrigger) { _ in
                dismissSearch()
            }
        }
    }
}
