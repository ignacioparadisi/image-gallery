import SwiftUI

struct AppDependencies {
    let photosRepository: PhotosRepository
    
    init(configuration: AppConfiguration) {
        let client = HTTPClient(accessKey: configuration.unsplashAccessKey)
        photosRepository = PhotosRepositoryImpl(client: client)
    }
}

@main struct ImageGalleryApp: App {
    let appDependencies: Result<AppDependencies, Error>
    
    init() {
        appDependencies = Result {
            AppDependencies(configuration: try AppConfiguration())
        }
    }
    var body: some Scene {
        WindowGroup {
            switch appDependencies {
            case .success(let dependencies):
                GalleryView(viewModel: GalleryViewModel(repository: dependencies.photosRepository))
            case .failure(let failure):
                Text("There was an error")
            }
            
        }
    }
}
