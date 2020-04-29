import UIKit

class MainCoordinator: Coordinator {
    private var navigationController: UINavigationController
    
    init() {
        navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
    }
    
    func start() -> UIViewController {
        let viewController = HomeViewController()
        navigationController.pushViewController(viewController, animated: false)
        return navigationController
    }
    
    func homeFeaturedItemTapped(for eventKey: ShowcaseEventKey) {
        let viewController = EventsViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
