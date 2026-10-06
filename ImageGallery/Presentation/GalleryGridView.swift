//
//  GalleryGridView.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import SwiftUI

struct PhotoGridView: View {
    @ObservedObject var viewModel: PhotoGridViewModel
    private let column = GridItem(.adaptive(minimum: 100), spacing: 2)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [column], spacing: 2) {
                ForEach(viewModel.photos) { photo in
                    if let url = photo.urls.thumb {
                        GalleryViewCell(url: URL(string: url))
                            .onAppear {
                                viewModel.loadNextPageIfNeeded(currentPhoto: photo)
                            }
                    }
                }
            }
        }
    }
}
