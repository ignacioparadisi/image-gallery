import SwiftUI

extension View {
    func photoDetail(_ presentation: PhotoPresentation?, onDismissed: @escaping () -> Void) -> some View {
        modifier(PhotoDetailModifier(presentation: presentation, onDismissed: onDismissed))
    }
}

private struct PhotoDetailModifier: ViewModifier {
    let presentation: PhotoPresentation?
    let onDismissed: () -> Void
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

private struct ClearPresentationBackground: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            content.presentationBackground(.clear)
        } else {
            content
        }
    }
}
