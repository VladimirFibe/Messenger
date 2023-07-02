import SwiftUI

final class ProfileViewController: BaseViewController {
    private lazy var rootView: BridgedView = {
        ProfileView(person: Person.MOCK_PERSON).bridge()
    }()
}

extension ProfileViewController {
    override func setupViews() {
        super.setupViews()
        addBridgedViewAsRoot(rootView)
    }
}
