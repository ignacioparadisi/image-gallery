//
//  PhotoListViewModel.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/5/26.
//

import Foundation
import Combine

final class PhotoListViewModel: ObservableObject {
    @Published private(set) var photos: [PhotoDTO] = []
}
