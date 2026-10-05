//
//  RemoteImage.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import SwiftUI

struct RemoteImage: View {
    @Environment(\.imageLoader) private var imageLoader
    let url: URL?
    @State private var image: CGImage?
    
    var body: some View {
        Color.gray.opacity(0.4)
            .overlay {
                if let image = image ?? imageLoader.cachedImage(url: url) {
                    Image(decorative: image, scale: 1)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .transition(.opacity)
                }
            }
            .task {
                // TODO: Handle error
                let loadedImage = try? await imageLoader.image(url: url)
                withAnimation(.smooth(duration: 0.1)) {
                    image = loadedImage
                }
            }
    }
}

#Preview {
    RemoteImage(
        url: URL(string: "https://images.unsplash.com/photo-1530281700549-e82e7bf110d6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDkzNjQ0fDB8MXxzZWFyY2h8MXx8RG9nfGVufDB8fHx8MTc5MTIxOTA4NXww&ixlib=rb-4.1.0&q=80&w=200")
    )
}

