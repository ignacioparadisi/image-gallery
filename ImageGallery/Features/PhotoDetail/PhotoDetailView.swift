//
//  PhotoDetailView.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import SwiftUI

struct PhotoDetailView: View {
    let presentation: PhotoPresentation
    let onDismissed: () -> Void

    @State private var isExpanded = false
    @State private var isDismissing = false
    @State private var dragOffset: CGSize = .zero

    private let animation = Animation.spring(response: 0.35, dampingFraction: 0.86)
    private let dismissDistance: CGFloat = 120

    private var photo: Photo { presentation.photo }

    private var dragProgress: CGFloat {
        min(abs(dragOffset.height) / dismissDistance, 1)
    }

    var body: some View {
        GeometryReader { proxy in
            let container = proxy.frame(in: .global)
            let frame = currentFrame(in: container)

            ZStack(alignment: .topLeading) {
                Color.black
                    .opacity(isExpanded ? 1 - dragProgress * 0.3 : 0)
                    .onTapGesture(perform: dismiss)
                    .accessibilityAction(.escape, dismiss)

                Content(photo: photo)
                    .frame(width: frame.width, height: frame.height)
                    .clipped()
                    .offset(x: frame.minX - container.minX, y: frame.minY - container.minY)
            }
        }
        .ignoresSafeArea()
        .contentShape(.rect)
        .gesture(dragToDismiss)
        .overlay(alignment: .topLeading) {
            closeButton
        }
        .onAppear {
            withAnimation(animation) {
                isExpanded = true
            }
        }
    }

    private var closeButton: some View {
        BackButton(action: dismiss)
            .padding(.horizontal)
            .opacity(isExpanded && dragOffset == .zero ? 1 : 0)
            .accessibilityLabel("Close")
    }

    private var dragToDismiss: some Gesture {
        DragGesture()
            .onChanged {
                dragOffset = $0.translation
            }
            .onEnded { value in
                if abs(value.translation.height) > dismissDistance {
                    dismiss()
                } else {
                    withAnimation(animation) { dragOffset = .zero }
                }
            }
    }

    private func currentFrame(in container: CGRect) -> CGRect {
        guard isExpanded else { return presentation.sourceFrame }
        return container
            .aspectFitting(width: CGFloat(photo.width), height: CGFloat(photo.height))
            .offsetBy(dx: dragOffset.width, dy: dragOffset.height)
    }

    private func dismiss() {
        guard !isDismissing else { return }
        isDismissing = true
        withAnimation(animation) {
            isExpanded = false
            dragOffset = .zero
        }
        Task {
            try? await Task.sleep(for: .milliseconds(350))
            onDismissed()
        }
    }
}

extension PhotoDetailView {
    struct Content: View {
        let photo: Photo
        
        var body: some View {
            RemoteImage(url: photo.url) {
                RemoteImage(url: photo.thumbnailURL)
            }
            .accessibilityLabel(photo.description ?? "Photo")
        }
    }
}
