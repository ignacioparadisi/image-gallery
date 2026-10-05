//
//  GalleryView.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import SwiftUI

struct GalleryView: View {
    @StateObject var viewModel: GalleryViewModel
    
    init(viewModel: GalleryViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    let column = GridItem(.adaptive(minimum: 100), spacing: 2)
                          
    var body: some View {
        Content()
            .onAppear {
                viewModel.loadFirstPageIfNeeded()
            }
    }
    
    @ViewBuilder
    func Content() -> some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .empty:
            Text("Empty")
        case .failure(let error):
            Text(error.localizedDescription)
        case .loaded:
            ScrollView {
                LazyVGrid(columns: [column], spacing: 2) {
                    ForEach(viewModel.photos) { photo in
                        if let url = photo.urls.thumb {
                            GalleryViewCell(url: URL(string: url))
                                .onAppear { viewModel.loadNextPageIfNeeded(currentPhoto: photo)
                                }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    GalleryView(
        viewModel: GalleryViewModel(
            repository: PreviewPhotosRepository()
        )
    )
}
