import Foundation

extension Localization {
    enum Configuration {
        static let missingAccessKey = String(
            localized: "Localization.Configuration.missingAccessKey",
            defaultValue: "Missing Unsplash access key"
        )
        static let missingAccessKeySuggestion = String(
            localized: "Localization.Configuration.missingAccessKeySuggestion",
            defaultValue: "Copy Template.xcconfig to Environment.xcconfig in App/Configuration, set UNSPLASH_ACCESS_KEY to your key, and run the app again."
        )
    }
}
