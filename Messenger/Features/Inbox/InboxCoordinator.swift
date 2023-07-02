import Foundation

final class InboxCoordinator: BaseCoordinator {
    override func start() {
        runInbox()
    }
    private func runInbox() {
        let controller = makeInbox()
        router.setRootModule(controller, hideBar: true)
    }
}

extension InboxCoordinator {
    private func makeInbox() -> BaseViewControllerProtocol {
        InboxViewController()
    }
}
