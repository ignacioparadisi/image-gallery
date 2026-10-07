//
//  AppDependencies.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import Foundation

struct AppDependencies {
    let photosRepository: PhotosRepository
    let imageLoader: ImageLoading
    
    init(configuration: AppConfiguration) {
        let client = HTTPClient(accessKey: configuration.unsplashAccessKey)
        photosRepository = PhotosRepositoryImpl(client: client)
        imageLoader = ImageLoader(session: URLSession.images)
    }
}
