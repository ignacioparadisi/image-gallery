//
//  BackButton.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/7/26.
//

import SwiftUI

struct BackButton: View {
    let action: () -> Void
    var body: some View {
        if #available(iOS 26, *) {
            GlassBackButton(action: action)
        } else {
            MaterialBackButton(action: action)
        }
    }
}

@available(iOS 26, *)
private struct GlassBackButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.backward")
                .font(.title3.weight(.semibold))
                .padding(5)
        }
        .buttonBorderShape(.circle)
        .buttonStyle(.glass)
    }
}

private struct MaterialBackButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.backward")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(.ultraThinMaterial, in: Circle())
        }
    }
}
