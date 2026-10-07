//
//  Localization+Feed.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/7/26.
//

import Foundation

extension Localization {
    enum Feed {
        static let title = String(localized: "Localization.Feed.title", defaultValue: "Feed")
        static let noRecentSearches = String(
            localized: "Localization.Feed.noRecentSearches",
            defaultValue: "No Recent Searches"
        )
    }
}
