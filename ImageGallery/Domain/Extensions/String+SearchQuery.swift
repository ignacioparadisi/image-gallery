//
//  String+SearchQuery.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/7/26.
//

import Foundation

extension String {
    /// The text trimmed and ready to search, or `nil` if there's nothing to search for.
    var searchQuery: String? {
        let query = trimmingCharacters(in: .whitespacesAndNewlines)
        return query.isEmpty ? nil : query
    }
}
