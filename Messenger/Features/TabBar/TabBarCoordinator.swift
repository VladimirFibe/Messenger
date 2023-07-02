import UIKit

final class TabBarCoordinator: BaseCoordinator {
    override func start() {
        runTab()
    }
    
    private func runTab() {
        let tabBar = makeTabBar()
        router.setRootModule(tabBar, hideBar: true)
        let modules = [makeInbox(), makeProfile()]
        modules.forEach { coordinator, _ in
            addDependency(coordinator)
            coordinator.start()
        }
        let viewControllers = modules.map { $0.1 }
        tabBar.setViewControllers(viewControllers, animated: false)
    }
}

extension TabBarCoordinator {
    private func makeTabBar() -> BaseViewControllerProtocol & UITabBarController {
        return BaseTabBarController()
    }
    
    private func makeInbox() -> (BaseCoordinator, UINavigationController) {
        let navigationController = UINavigationController()
        let coordinator = InboxCoordinator(router: RouterImpl(rootController: navigationController))
        navigationController.tabBarItem = tabItem(for: .inbox)
        return (coordinator, navigationController)
    }
    
    private func makeProfile() -> (BaseCoordinator, UINavigationController) {
        let navigationController = UINavigationController()
        let coordinator = ProfileCoordinator(router: RouterImpl(rootController: navigationController))
        navigationController.tabBarItem = tabItem(for: .profile)
        return (coordinator, navigationController)
    }
    
    private func tabItem(for type: TabItem) -> UITabBarItem {
        let item = UITabBarItem(title: nil, image: UIImage(systemName: type.icon), tag: type.rawValue)
        item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: -6)
        return item
    }
}
