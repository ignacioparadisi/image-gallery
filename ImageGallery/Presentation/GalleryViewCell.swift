//
//  GalleryViewCell.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import SwiftUI

struct GalleryViewCell: View {
    let url: URL?
    var body: some View {
        Color.gray
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                RemoteImage(url: url)
            }
            .clipped()
            .contentShape(.rect)
    }
}
