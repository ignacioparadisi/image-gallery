import CoreGraphics
import Foundation
import Testing
@testable import ImageGallery

struct ImageLoaderTests {
    private func makeImage(width: Int, height: Int) throws -> CGImage {
        let context = try #require(CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ))
        return try #require(context.makeImage())
    }

    @Test func costIsTheDecodedBitmapSize() throws {
        let image = try makeImage(width: 100, height: 50)

        #expect(ImageLoader.cost(of: image) == 100 * 4 * 50)
    }

    @Test func defaultCostLimitIsCappedAt150MB() {
        #expect(ImageLoader.defaultCostLimit > 0)
        #expect(ImageLoader.defaultCostLimit <= 150 * 1024 * 1024)
    }
}
