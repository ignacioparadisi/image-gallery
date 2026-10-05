//
//  RemoteImage.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import SwiftUI

struct RemoteImage: View {
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                .resizable()
                .aspectRatio(contentMode: .fill)
            case .empty:
                Color.gray
            case .failure:
                Color.gray
            @unknown default:
                Color.gray
            }
        }
    }
}

#Preview {
    RemoteImage(
        url: URL(string: "https://images.unsplash.com/photo-1530281700549-e82e7bf110d6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDkzNjQ0fDB8MXxzZWFyY2h8MXx8RG9nfGVufDB8fHx8MTc5MTIxOTA4NXww&ixlib=rb-4.1.0&q=80&w=200")
    )
}

