//
//  GalleryGridView.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import SwiftUI

struct PhotoGridView: View {
    let photos: [Photo]
    @Binding var selection: Photo?
    private let column = GridItem(.adaptive(minimum: 130), spacing: 2)
    let onLoadMore: ((Photo) -> Void)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [column], spacing: 2) {
                ForEach(photos) { photo in
                    PhotoGridCell(url: photo.thumbnailURL)
                        .onTapGesture {
                            selection = photo
                        }
                        .onAppear {
                            onLoadMore(photo)
                        }
                }
            }
        }
    }
}
