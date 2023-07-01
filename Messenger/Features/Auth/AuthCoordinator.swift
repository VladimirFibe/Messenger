import Foundation

final class AuthCoordinator: BaseCoordinator {
    override func start() {
        runAuth()
    }
    
    private func runAuth() {
        let controller = makeAuth()
        controller.view.backgroundColor = .systemPink
        router.setRootModule(controller)
    }
}

extension AuthCoordinator {
    private func makeAuth() -> BaseViewControllerProtocol {
        BaseViewController()
    }
}
