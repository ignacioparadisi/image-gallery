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
                .environment(\.imageLoader, dependencies.imageLoader)
                .environment(\.router, router)
            case .failure(let failure):
                Text("There was an error")
            }
            
        }
    }
}
