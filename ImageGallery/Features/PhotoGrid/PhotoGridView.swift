//
//  GalleryGridView.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import SwiftUI

struct PhotoGridView: View {
    @ObservedObject var viewModel: PhotoGridViewModel
    let namespace: Namespace.ID
    @Binding var selection: Photo?
    private let column = GridItem(.adaptive(minimum: 130), spacing: 2)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [column], spacing: 2) {
                ForEach(viewModel.photos) { photo in
                    PhotoGridCell(url: photo.thumbnailURL)
                        .photoViewerSource(photo)
                        .onAppear {
                            viewModel.loadNextPageIfNeeded(currentPhoto: photo)
                        }
                }
            }
        }
        .alert(error: $viewModel.error) {
            Button("Cancel") {
                
            }
            Button("Retry") {
                
            }
        }
    }
}
