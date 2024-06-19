import UIKit
import StarWarsAPI

@MainActor
public class AppCoordinator {
    private let window: UIWindow
    private let starWarsClient = StarWarsClient.live
    
    public init(window: UIWindow) {
        self.window = window
    }
    
    public func start() {
        self.window.rootViewController = homeScene()
        self.window.makeKeyAndVisible()
    }
}

// MARK: - Scenes
private extension AppCoordinator {
    func homeScene() -> UIViewController {
        let homeVC = HomeVC()
        homeVC.viewControllers = [
            paginatedListScene(starWarsClient.getFilms),
            paginatedListScene(starWarsClient.getPeople),
        ]
        return homeVC
    }
    
    func paginatedListScene<T: StarWarsModel & HasViewControllerTitle & PaginatedListCellModel & DetailsModel>(
        _ callback: @escaping PaginatedRequest<T>
    ) -> UIViewController {
        let vm = PaginatedListVM(title: T.viewControllerTitle, fetchCallback: callback)
        let vc = PaginatedListVC(viewModel: vm) { [weak self] source, item in
            self?.showDetailsView(source: source, item: item)
        }
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.tabBarItem = UITabBarItem.init(title: vm.title, image: nil, selectedImage: nil)
        
        return navigationController
    }
    
    func detailsScene<T: StarWarsModel & DetailsModel>(_ model: T) -> UIViewController {
        let vm = DetailsVM(model: model)
        let vc = DetailsVC(viewModel: vm)
        return vc
    }
}

// MARK: - Routes
private extension AppCoordinator {
    func showDetailsView<T: StarWarsModel & DetailsModel>(source: UIViewController, item: T) {
        guard let navigationController = source.navigationController else {
            assertionFailure("\(source) has no navigation controller")
            return
        }
        
        navigationController.pushViewController(detailsScene(item), animated: true)
    }
}

// MARK: - View Controller Titles
protocol HasViewControllerTitle {
    static var viewControllerTitle: String { get }
}

extension Film: HasViewControllerTitle {
    static var viewControllerTitle: String { .tr.common.films }
}

extension Person: HasViewControllerTitle {
    static var viewControllerTitle: String { .tr.common.people }
}
