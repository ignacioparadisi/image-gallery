//
//  ConfigurationErrorView.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/7/26.
//

import SwiftUI

struct ConfigurationErrorView: View {
    let error: Error

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text((error as? LocalizedError)?.errorDescription ?? "The app couldn't start")
                .font(.headline)
            if let suggestion = (error as? LocalizedError)?.recoverySuggestion {
                Text(suggestion)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
}
