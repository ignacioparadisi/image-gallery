import SwiftUI

@main struct ImageGalleryApp: App {
    @StateObject private var router: Router = Router()
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
                NavigationStack(path: $router.path) {
                    FeedView(viewModel: FeedViewModel(repository: dependencies.photosRepository))
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .search(let query):
                                SearchView(viewModel: SearchViewModel(query: query, repository: dependencies.photosRepository))
                            }
                        }
                }
                .photoDetail(router.presentedPhoto, onDismissed: router.dismissPhoto)
                .environment(\.imageLoader, dependencies.imageLoader)
                .environmentObject(router)
            case .failure(let error):
                ConfigurationErrorView(error: error)
            }
            
        }
    }
}
