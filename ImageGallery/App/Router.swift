//
//  Router.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import SwiftUI
import Combine

final class Router: ObservableObject {
    @Published var path = NavigationPath()
    @Published var presentedPhoto: PhotoPresentation?

    func navigate(to route: Route) {
        path.append(route)
    }

    func showPhoto(_ photo: Photo, from sourceFrame: CGRect) {
        withoutAnimation {
            presentedPhoto = PhotoPresentation(photo: photo, sourceFrame: sourceFrame)
        }
    }

    func dismissPhoto() {
        withoutAnimation {
            presentedPhoto = nil
        }
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}

enum Route: Hashable {
    case search(query: String)
}
