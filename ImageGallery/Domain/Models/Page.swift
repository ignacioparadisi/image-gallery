//
//  Page.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import Foundation

struct Page<T> {
    let total: Int
    let totalPages: Int
    let results: [T]
}
