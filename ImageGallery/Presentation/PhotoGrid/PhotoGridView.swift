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
    private let column = GridItem(.adaptive(minimum: 100), spacing: 2)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [column], spacing: 2) {
                ForEach(viewModel.photos) { photo in
                    GalleryViewCell(url: photo.thumbnailURL)
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


struct PhotoDetailView: View {
    @Binding var photo: Photo?
    let namespace: Namespace.ID
    var body: some View {
        if let photo {
            ZStack {
                Color.black
                RemoteImage(url: photo.url)
                    .aspectRatio(CGFloat(photo.width) / CGFloat(photo.height), contentMode: .fit)
                    .matchedGeometryEffect(id: photo.id, in: namespace)
                    .onTapGesture {
                        withAnimation {
                            self.photo = nil
                        }
                    }
            }
            .ignoresSafeArea()
        } else {
            EmptyView()
        }
    }
}
