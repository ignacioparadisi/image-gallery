import Foundation
import Testing
@testable import ImageGallery

@MainActor
struct PhotosRepositoryImplTests {
    private static func photosJSON(count: Int) -> Data {
        let photos = (0..<count).map { #"{"id": "photo-\#($0)", "width": 100, "height": 100, "urls": {}}"# }
        return Data("[\(photos.joined(separator: ","))]".utf8)
    }

    private func makeRepository(photoCount: Int, headers: [String: String]) -> PhotosRepositoryImpl {
        let body = Self.photosJSON(count: photoCount)
        let session = MockSession { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: headers)!
            return (body, response)
        }
        return PhotosRepositoryImpl(client: HTTPClient(session: session, host: "api.unsplash.com", authorization: "test"))
    }

    @Test func feedUsesThePaginationHeaders() async throws {
        let repository = makeRepository(photoCount: 30, headers: ["X-Total": "95"])

        let page = try await repository.fetchPhotos(page: 1, pageSize: 30)

        #expect(page.total == 95)
        #expect(page.totalPages == 4)
        #expect(page.results.count == 30)
    }

    @Test func feedReadsLowercaseHeaders() async throws {
        let repository = makeRepository(photoCount: 30, headers: ["x-total": "60"])

        let page = try await repository.fetchPhotos(page: 1, pageSize: 30)

        #expect(page.totalPages == 2)
    }

    @Test func withoutHeadersAFullPageMeansThereIsAnotherOne() async throws {
        let repository = makeRepository(photoCount: 30, headers: [:])

        let page = try await repository.fetchPhotos(page: 2, pageSize: 30)

        #expect(page.totalPages == 3)
    }

    @Test func withoutHeadersAShortPageIsTheLastOne() async throws {
        let repository = makeRepository(photoCount: 12, headers: [:])

        let page = try await repository.fetchPhotos(page: 2, pageSize: 30)

        #expect(page.totalPages == 2)
    }
}
