import Foundation
@testable import ImageGallery

@MainActor
final class StubPhotosRepository: PhotosRepository {
    var photos: [Photo] = []

    func fetchPhotos(page: Int, pageSize: Int) async throws -> Page<Photo> {
        Page(total: photos.count, totalPages: 1, results: photos)
    }

    func searchPhotos(text: String, page: Int, pageSize: Int) async throws -> Page<Photo> {
        Page(total: photos.count, totalPages: 1, results: photos)
    }
}

extension Photo {
    static func stub(id: String) -> Photo {
        Photo(
            id: id,
            width: 100,
            height: 100,
            description: nil,
            blurHash: nil,
            thumbnailURL: URL(string: "https://images.unsplash.com/\(id)-thumb"),
            url: URL(string: "https://images.unsplash.com/\(id)")
        )
    }
}
