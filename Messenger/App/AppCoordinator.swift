import Foundation

final class AppCoordinator: BaseCoordinator {
    override func start() {
        runLesson()
    }
    
    private func runAuth() {
        let coordinator = AuthCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runTabbar() {
        let coordinator = TabBarCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runLesson() {
        let coordinator = LessonCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
    }
}
