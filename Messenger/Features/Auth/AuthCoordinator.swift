import Foundation

final class AuthCoordinator: BaseCoordinator {
    override func start() {
        runAuth()
    }
    
    private func runAuth() {
        let controller = makeAuth()
        router.setRootModule(controller, hideBar: true)
    }
}

extension AuthCoordinator {
    private func makeAuth() -> BaseViewControllerProtocol {
        AuthViewController()
    }
}
