//
//  EnvironmentValues.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var imageLoader: ImageLoading = ImageLoader(session: URLSession.images)
    @Entry var router: Router = Router()
}
