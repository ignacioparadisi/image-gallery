//
//  PhotoDetailView.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import SwiftUI

struct PhotoDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let photo: Photo
    
    var body: some View {
        Text(photo.description ?? "")
            .safeAreaInset(edge: .top) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                }
            }
    }
}
