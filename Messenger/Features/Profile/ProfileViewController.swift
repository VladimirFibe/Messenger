import SwiftUI

final class ProfileViewController: BaseViewController {
    private lazy var rootView: BridgedView = {
        Color.blue.bridge()
    }()
}

extension ProfileViewController {
    override func setupViews() {
        super.setupViews()
        addBridgedViewAsRoot(rootView)
    }
}
