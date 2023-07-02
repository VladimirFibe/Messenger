import Foundation

final class ProfileCoordinator: BaseCoordinator {
    override func start() {
        runProfile()
    }
    
    private func runProfile() {
        let controller = makeProfile()
        router.setRootModule(controller)
    }
}

extension ProfileCoordinator {
    private func makeProfile() -> BaseViewControllerProtocol {
        ProfileViewController()
    }
}
