import SwiftUI

final class InboxViewController: BaseViewController {
    private lazy var rootView: BridgedView = {
        ProfileView(person: Person.MOCK_PERSON).bridge()
    }()
}

extension InboxViewController {
    override func setupViews() {
        super.setupViews()
        addBridgedViewAsRoot(rootView)
    }
}
