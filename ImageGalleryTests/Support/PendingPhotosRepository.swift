import Foundation
@testable import ImageGallery

/// Search responses wait until the test completes them, to control the order they arrive in.
@MainActor
final class PendingPhotosRepository: PhotosRepository {
    private var pending: [String: CheckedContinuation<Page<Photo>, Error>] = [:]

    func isWaiting(for text: String) -> Bool {
        pending[text] != nil
    }

    func complete(_ text: String, with photos: [Photo]) {
        pending.removeValue(forKey: text)?.resume(returning: Page(total: photos.count, totalPages: 1, results: photos))
    }

    func fetchPhotos(page: Int, pageSize: Int) async throws -> Page<Photo> {
        Page(total: 0, totalPages: 0, results: [])
    }

    func searchPhotos(text: String, page: Int, pageSize: Int) async throws -> Page<Photo> {
        try await withCheckedThrowingContinuation { continuation in
            pending[text] = continuation
        }
    }
}
