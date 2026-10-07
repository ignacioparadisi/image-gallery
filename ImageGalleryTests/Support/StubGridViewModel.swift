import Foundation
@testable import ImageGallery

@MainActor
final class StubGridViewModel: PhotoGridViewModel {
    var pages: [Int: Page<Photo>] = [:]
    private(set) var requestedPages: [Int] = []

    override func loadPage(_ page: Int, pageSize: Int) async throws -> Page<Photo> {
        requestedPages.append(page)
        return pages[page] ?? Page(total: 0, totalPages: 0, results: [])
    }
}

@MainActor
func waitUntil(_ condition: () -> Bool) async throws {
    for _ in 0..<100 where !condition() {
        try await Task.sleep(for: .milliseconds(10))
    }
}
