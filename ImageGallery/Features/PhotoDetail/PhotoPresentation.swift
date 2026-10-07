import CoreGraphics

struct PhotoPresentation: Identifiable, Equatable {
    var id: Photo.ID { photo.id }
    let photo: Photo
    let sourceFrame: CGRect
}
