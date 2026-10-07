//
//  ErrorView.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/7/26.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    
    var retry: (() -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text((error as? LocalizedError)?.errorDescription ?? "Error")
                .font(.headline)
            if let suggestion = (error as? LocalizedError)?.recoverySuggestion {
                Text(suggestion)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if let retry {
                Button("Retry") {
                    retry()
                }
            }
        }
        .padding()
    }
}

struct ShortErrorView: View {
    let error: Error
    
    var retry: (() -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text((error as? LocalizedError)?.errorDescription ?? "Error")
            
            if let retry {
                Button("Retry") {
                    retry()
                }
            }
        }
        .padding()
    }
}
