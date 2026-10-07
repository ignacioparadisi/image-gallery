//
//  GalleryView.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import SwiftUI

struct GalleryView: View {
    @Namespace private var namespace
    private let column = GridItem(.adaptive(minimum: 100), spacing: 2)
    
    @StateObject private var viewModel: GalleryViewModel
    
    init(viewModel: GalleryViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            GalleryContentView(viewModel: viewModel, namespace: namespace)
                .softScrollEdges([.top])
                .searchable(text: $viewModel.query, prompt: "Search photos")
                .navigationTitle("Feed")
                .toolbarBackground(.visible, for: .navigationBar)
        }
        .photoViewer()
        .onAppear {
            viewModel.fetchFeed()
        }
    }
}
