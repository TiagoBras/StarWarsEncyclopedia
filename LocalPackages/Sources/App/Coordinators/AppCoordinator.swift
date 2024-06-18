import UIKit
import StarWarsAPI

@MainActor
public class AppCoordinator {
    private let window: UIWindow
    private let starWarsClient = StarWarsClient.test
    
    public init(window: UIWindow) {
        self.window = window
    }
    
    public func start() {
        let homeVC = HomeVC()
        homeVC.viewControllers = [
            filmsScene()
        ]
        
        self.window.rootViewController = homeVC
        self.window.makeKeyAndVisible()
    }
    
    private func filmsScene() -> UINavigationController {
        let vm = PaginatedListVM(title: "Films", fetchCallback: starWarsClient.getFilms)
        let vc = PaginatedListVC(viewModel: vm)
        return UINavigationController(rootViewController: vc)
    }
}

