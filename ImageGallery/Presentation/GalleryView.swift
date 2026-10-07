//
//  GalleryView.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import SwiftUI

struct SoftScrollEdges: ViewModifier {
    let edges: Edge.Set
    
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .scrollEdgeEffectStyle(.soft, for: edges)
        } else {
            content
        }
    }
}

extension View {
    @ViewBuilder
    func softScrollEdges(_ edges: Edge.Set) -> some View {
        self
            .modifier(SoftScrollEdges(edges: edges))
    }
}

struct GalleryView: View {
    private let column = GridItem(.adaptive(minimum: 100), spacing: 2)
    
    @StateObject private var viewModel: GalleryViewModel
    
    init(viewModel: GalleryViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            GalleryContentView(viewModel: viewModel)
                .softScrollEdges([.top])
                .searchable(text: $viewModel.query, prompt: "Search photos")
                .navigationTitle("Feed")
                .toolbarBackground(.visible, for: .navigationBar)
        }
        .onAppear {
            viewModel.fetchFeed()
        }
    }
}
