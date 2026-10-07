//
//  Localization+PhotoGrid.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/7/26.
//

import Foundation

extension Localization {
    enum PhotoGrid {
        static let emptyResults = String(
            localized: "Localization.PhotoGrid.emptyResults",
            defaultValue: "No Results"
        )
        static let photoDescriptionPlaceholder = String(
            localized: "Localization.PhotoGrid.photoDescriptionPlaceholder",
            defaultValue: "The image has no description"
        )
    }
}
