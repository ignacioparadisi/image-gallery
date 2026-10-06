//
//  GalleryView.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import SwiftUI

struct GalleryView: View {
    private let column = GridItem(.adaptive(minimum: 100), spacing: 2)
    
    @StateObject private var viewModel: GalleryViewModel
    
    init(viewModel: GalleryViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            GalleryContentView(viewModel: viewModel)
                .searchable(text: $viewModel.query, prompt: "Search photos")
        }
        .onAppear {
            viewModel.fetchFeed()
        }
    }
}

struct GalleryContentView: View {
    @ObservedObject var viewModel: GalleryViewModel
    
    private var isSearching: Bool {
        if viewModel.searchViewModel == nil {
            return false
        }
        return true
    }
    
    var body: some View {
        ZStack {
            PhotoGridView(viewModel: viewModel.feedViewModel)
                .opacity(isSearching ? 0 : 1)
            
            if let searchViewModel = viewModel.searchViewModel {
                PhotoGridView(viewModel: searchViewModel)
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.default, value: viewModel.searchViewModel == nil)
    }
}
