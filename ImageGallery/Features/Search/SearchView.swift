//
//  SearchView.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.router) private var router
    @StateObject private var viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        PhotoGridView(photos: viewModel.photos, selection: $viewModel.selectedPhoto) {
            viewModel.loadNextPageIfNeeded(currentPhoto: $0)
        }
        .navigationTitle(viewModel.query)
        .navigationBarTitleDisplayMode(.inline)
        .softScrollEdges(.top)
        .onAppear {
            viewModel.loadFirstPageIfNeeded()
        }
    }
}

