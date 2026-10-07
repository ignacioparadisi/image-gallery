//
//  AppDependencies.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import Foundation

struct AppDependencies {
    let photosRepository: PhotosRepository
    let recentSearchesRepository: RecentSearchesRepository
    let imageLoader: ImageLoading

    init(configuration: AppConfiguration) {
        let client = HTTPClient(
            host: configuration.httpHost,
            authorization: "Client-ID \(configuration.unsplashAccessKey)"
        )
        photosRepository = PhotosRepositoryImpl(client: client)
        recentSearchesRepository = UserDefaultsRecentSearchesRepository()
        imageLoader = ImageLoader(session: URLSession.images)
    }
}
