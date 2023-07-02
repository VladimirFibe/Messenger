import SwiftUI

final class AuthViewController: BaseViewController {
    private lazy var rootView: BridgedView = {
        LoginView().bridge()
    }()
}

extension AuthViewController {
    override func setupViews() {
        super.setupViews()
        addBridgedViewAsRoot(rootView)
    }
}
