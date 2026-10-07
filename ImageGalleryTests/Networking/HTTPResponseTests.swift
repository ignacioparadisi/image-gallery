import Foundation
import Testing
@testable import ImageGallery

struct HTTPResponseTests {
    private func makeResponse(headers: [String: String]) -> HTTPResponse<String> {
        let response = HTTPURLResponse(
            url: URL(string: "https://api.unsplash.com/photos")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: headers
        )!
        return HTTPResponse(body: "", response: response)
    }

    @Test(arguments: ["X-Total", "x-total", "X-TOTAL"])
    func headerLookupIgnoresCase(name: String) {
        let response = makeResponse(headers: ["X-Total": "95"])

        #expect(response.header(name) == "95")
    }

    @Test func headersSentInLowercaseAreFound() {
        let response = makeResponse(headers: ["x-total": "95"])

        #expect(response.header("X-Total") == "95")
    }

    @Test func missingHeaderIsNil() {
        let response = makeResponse(headers: [:])

        #expect(response.header("X-Total") == nil)
    }
}
