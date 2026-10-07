import Foundation

extension Localization {
    enum Network {
        static let invalidURL = String(
            localized: "Localization.Network.invalidURL",
            defaultValue: "The URL is not valid"
        )
        static let invalidResponse = String(
            localized: "Localization.Network.invalidResponse",
            defaultValue: "The response is not valid"
        )
        static let unauthorized = String(
            localized: "Localization.Network.unauthorized",
            defaultValue: "Unauthorized"
        )
        static let rateLimited = String(
            localized: "Localization.Network.rateLimited",
            defaultValue: "You've reached the request limit rate for this hour"
        )
        static let decodingFailed = String(
            localized: "Localization.Network.decodingFailed",
            defaultValue: "There was an error reading the response"
        )
        static let offline = String(
            localized: "Localization.Network.offline",
            defaultValue: "You're offline"
        )
        static let connectionFailed = String(
            localized: "Localization.Network.connectionFailed",
            defaultValue: "Couldn't connect to Unsplash"
        )

        static func httpError(statusCode: Int) -> String {
            String(
                localized: "Localization.Network.httpError",
                defaultValue: "Network error with code \(statusCode)"
            )
        }
    }
}
