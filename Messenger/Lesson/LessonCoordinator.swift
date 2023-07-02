import Foundation

final class LessonCoordinator: BaseCoordinator {
    override func start() {
        runConversation()
    }
    private func runConversation() {
        let controller = makeConversation()
        router.setRootModule(controller)
        let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
        if !isLoggedIn {
            runLogin()
        }
    }
    
    private func runLogin() {
        let controller = makeLogin()
        controller.modalPresentationStyle = .fullScreen
        router.present(controller, animated: false)
    }
}

extension LessonCoordinator {
    private func makeConversation() -> BaseViewControllerProtocol {
        ConversationLessonViewController()
    }
    
    private func makeLogin() -> BaseViewControllerProtocol {
        LoginLessonViewController()
    }
}
