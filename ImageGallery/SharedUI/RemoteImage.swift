//
//  RemoteImage.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import SwiftUI

extension RemoteImage where Placeholder == Color {
    init(url: URL?) {
        self.init(url: url) { Color.gray }
    }
}

struct RemoteImage<Placeholder>: View where Placeholder: View {
    @Environment(\.imageLoader) private var imageLoader
    let url: URL?
    let placeholder: () -> Placeholder?
    @State private var image: CGImage?
    
    init(
        url: URL?,
        @ViewBuilder placeholder: @escaping () -> Placeholder? = { nil }
    ) {
        self.url = url
        self.placeholder = placeholder
    }
    
    var body: some View {
        Color.gray.opacity(0.4)
            .overlay {
                if let image = image ?? imageLoader.cachedImage(url: url) {
                    Image(decorative: image, scale: 1)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .transition(.opacity)
                } else {
                    placeholder()
                }
            }
            .task {
                let loadedImage = try? await imageLoader.image(url: url)
                withAnimation(.smooth(duration: 0.1)) {
                    image = loadedImage
                }
            }
            .onDisappear { image = nil }
    }
}

#Preview {
    RemoteImage(
        url: URL(string: "https://images.unsplash.com/photo-1530281700549-e82e7bf110d6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDkzNjQ0fDB8MXxzZWFyY2h8MXx8RG9nfGVufDB8fHx8MTc5MTIxOTA4NXww&ixlib=rb-4.1.0&q=80&w=200")
    ) { Color.gray }
}

