//
//  PhotoViewerOverlay.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import SwiftUI
import Combine

/// Which photo the viewer shows, and where on screen it was tapped.
final class PhotoViewerPresenter: ObservableObject {
    struct Presentation: Equatable {
        let photo: Photo
        let sourceFrame: CGRect
    }

    @Published private(set) var presentation: Presentation?

    func present(_ photo: Photo, from sourceFrame: CGRect) {
        presentation = Presentation(photo: photo, sourceFrame: sourceFrame)
    }

    func dismiss() {
        presentation = nil
    }
}

struct PhotoViewerOverlay: View {
    @EnvironmentObject private var presenter: PhotoViewerPresenter

    var body: some View {
        GeometryReader { proxy in
            if let presentation = presenter.presentation {
                PhotoViewerTransition(
                    presentation: presentation,
                    container: proxy.frame(in: .global),
                    onDismissed: presenter.dismiss
                )
                .id(presentation.photo.id)
            }
        }
        .ignoresSafeArea()
    }
}

private struct PhotoViewerTransition: View {
    let presentation: PhotoViewerPresenter.Presentation
    let container: CGRect
    let onDismissed: () -> Void

    @State private var isExpanded = false
    @State private var dragOffset: CGSize = .zero

    private let animation = Animation.spring(response: 0.35, dampingFraction: 0.86)
    private let dismissDistance: CGFloat = 120

    private var photo: Photo { presentation.photo }

    private var expandedFrame: CGRect {
        container.aspectFitting(width: CGFloat(photo.width), height: CGFloat(photo.height))
            .offsetBy(dx: dragOffset.width, dy: dragOffset.height)
    }

    private var currentFrame: CGRect {
        isExpanded ? expandedFrame : presentation.sourceFrame
    }

    /// 0 when centered, 1 when dragged far enough to dismiss.
    private var dragProgress: CGFloat {
        min(abs(dragOffset.height) / dismissDistance, 1)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black
                .opacity(isExpanded ? 1 - dragProgress * 0.3 : 0)

            RemoteImage(url: photo.url) {
                RemoteImage(url: photo.thumbnailURL)
            }
            .frame(width: currentFrame.width, height: currentFrame.height)
            .clipped()
            .offset(x: currentFrame.minX - container.minX, y: currentFrame.minY - container.minY)
            .accessibilityLabel(photo.description ?? "Photo")
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: dismiss)
        .gesture(dragToDismiss)
        .accessibilityAddTraits(.isModal)
        .accessibilityAction(.escape, dismiss)
        .onAppear {
            withAnimation(animation) { isExpanded = true }
        }
    }

    private var dragToDismiss: some Gesture {
        DragGesture()
            .onChanged { dragOffset = $0.translation }
            .onEnded { value in
                if abs(value.translation.height) > dismissDistance {
                    dismiss()
                } else {
                    withAnimation(animation) { dragOffset = .zero }
                }
            }
    }

    private func dismiss() {
        withAnimation(animation) {
            isExpanded = false
            dragOffset = .zero
        }
        // withAnimation(completion:) needs iOS 17, so wait for the spring to settle.
        Task {
            try? await Task.sleep(for: .milliseconds(350))
            onDismissed()
        }
    }
}

extension CGRect {
    /// The largest rect with the given proportions that fits inside this one, centered.
    func aspectFitting(width: CGFloat, height: CGFloat) -> CGRect {
        guard width > 0, height > 0, self.width > 0, self.height > 0 else { return self }
        let scale = min(self.width / width, self.height / height)
        let size = CGSize(width: width * scale, height: height * scale)
        return CGRect(x: midX - size.width / 2, y: midY - size.height / 2, width: size.width, height: size.height)
    }
}


extension View {
    /// Installs the full-screen photo viewer above this view. Apply once, outside the NavigationStack.
    func photoViewer() -> some View {
        modifier(PhotoViewerContainer())
    }

    /// Makes this view open `photo` in the viewer when tapped, zooming from its frame.
    func photoViewerSource(_ photo: Photo) -> some View {
        modifier(PhotoViewerSource(photo: photo))
    }
}

private struct PhotoViewerContainer: ViewModifier {
    @StateObject private var presenter = PhotoViewerPresenter()

    func body(content: Content) -> some View {
        content
            .overlay { PhotoViewerOverlay() }
            .environmentObject(presenter)
    }
}

private struct PhotoViewerSource: ViewModifier {
    let photo: Photo
    @EnvironmentObject private var presenter: PhotoViewerPresenter

    private var isPresented: Bool {
        presenter.presentation?.photo.id == photo.id
    }

    func body(content: Content) -> some View {
        content
            .opacity(isPresented ? 0 : 1)
            .overlay {
                GeometryReader { proxy in
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            presenter.present(photo, from: proxy.frame(in: .global))
                        }
                }
            }
            .accessibilityAddTraits(.isButton)
    }
}
