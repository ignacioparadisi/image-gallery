//
//  GalleryGridView.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import SwiftUI

struct PhotoGridView: View {
    let photos: [Photo]
    var hiddenPhotoID: Photo.ID?
    let onSelect: (Photo, CGRect) -> Void
    let onLoadMore: ((Photo) -> Void)
    private let column = GridItem(.adaptive(minimum: 130), spacing: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [column], spacing: 2) {
                ForEach(photos) { photo in
                    PhotoGridCell(url: photo.thumbnailURL)
                        .opacity(photo.id == hiddenPhotoID ? 0 : 1)
                        .overlay {
                            GeometryReader { proxy in
                                Color.clear
                                    .contentShape(.rect)
                                    .onTapGesture {
                                        onSelect(photo, proxy.frame(in: .global))
                                    }
                            }
                        }
                        .accessibilityAddTraits(.isButton)
                        .onAppear {
                            onLoadMore(photo)
                        }
                }
            }
        }
    }
}
