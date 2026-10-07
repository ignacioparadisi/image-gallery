//
//  Configuration.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation

struct AppConfiguration {
    let httpHost: String = "api.unsplash.com"
    let unsplashAccessKey: String
}

/// Init is placed in an extension so the struct doesn't lose the default init
extension AppConfiguration {
    enum Error: LocalizedError {
        case missingKey(String)
        
        var errorDescription: String? {
            "Missing Unsplash access key"
        }

        var recoverySuggestion: String? {
            "Copy Template.xcconfig to Environment.xcconfig in App/Configuration, set UNSPLASH_ACCESS_KEY to your key, and run the app again."
        }
    }
    
    init(bundle: Bundle = .main) throws {
        let dictionaryKey = "UNSPLASH_ACCESS_KEY"
        guard let key = bundle.object(forInfoDictionaryKey: dictionaryKey) as? String, key.isEmpty == false else {
            throw Error.missingKey(dictionaryKey)
        }
        unsplashAccessKey = key
    }
}
