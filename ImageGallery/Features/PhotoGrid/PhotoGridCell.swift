//
//  GalleryViewCell.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import SwiftUI

struct PhotoGridCell: View {
    let url: URL?
    let description: String?
    var body: some View {
        Color.gray
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                ZStack(alignment: .bottom) {
                    RemoteImage(url: url)
                    Text(description ?? Localization.PhotoGrid.photoDescriptionPlaceholder)
                        .foregroundStyle(.white)
                        .font(.caption)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity)
                        .padding(5)
                        .background {
                            LinearGradient(
                                colors: [.black.opacity(0.1), .black],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                }
            }
            .clipped()
            .contentShape(.rect)
    }
}
