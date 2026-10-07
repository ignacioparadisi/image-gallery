import CoreGraphics

struct PhotoPresentation: Identifiable, Equatable {
    let photo: Photo
    let sourceFrame: CGRect

    var id: Photo.ID { photo.id }
}
