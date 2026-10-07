//
//  Localizable.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/7/26.
//

import Foundation

enum Localization {
    enum Button {
        static let close = String(localized: "Localization.Button.close", defaultValue: "Close")
        static let retry = String(localized: "Localization.Button.retry", defaultValue: "Retry")
    }
    
    enum Error {
        static let generalError = String(localized: "Localization.Error.generalError", defaultValue: "Error")
    }
}
