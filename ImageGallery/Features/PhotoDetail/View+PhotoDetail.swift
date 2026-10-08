import SwiftUI

extension View {
    /// Presents the Photo Detail in full screen with no animation
    func photoDetail(_ presentation: PhotoPresentation?, onDismissed: @escaping () -> Void) -> some View {
        modifier(PhotoDetailModifier(presentation: presentation, onDismissed: onDismissed))
    }
}

/// Presents the Photo Detail in full screen with no animation
private struct PhotoDetailModifier: ViewModifier {
    /// Photo to be presented
    let presentation: PhotoPresentation?
    /// Action to be executed when the full screen cover is dismissed
    let onDismissed: () -> Void
    /// Used to prevent a slide-in effect when presenting in iOS 27
    @State private var presented: PhotoPresentation?

    func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $presented) { presentation in
                PhotoDetailView(presentation: presentation, onDismissed: onDismissed)
                    .modifier(ClearPresentationBackground())
            }
            .onChange(of: presentation) { newValue in
                withoutAnimation {
                    presented = newValue
                }
            }
    }
}

/// Sets a clear background for the presented view for iOS 16.4 and above.
private struct ClearPresentationBackground: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            content.presentationBackground(.clear)
        } else {
            content
        }
    }
}
