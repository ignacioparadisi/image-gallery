import SwiftUI

struct AppDependencies {
    let photosRepository: PhotosRepository
    let imageLoader: ImageLoading
    
    init(configuration: AppConfiguration) {
        let client = HTTPClient(accessKey: configuration.unsplashAccessKey)
        photosRepository = PhotosRepositoryImpl(client: client)
        
        let session = URLSession(configuration: .default)
        imageLoader = ImageLoader(session: URLSession.images)
    }
}

extension EnvironmentValues {
    @Entry var imageLoader: ImageLoading = ImageLoader(session: URLSession.images)
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
                    .environment(\.imageLoader, dependencies.imageLoader)
            case .failure(let failure):
                Text("There was an error")
            }
            
        }
    }
}
