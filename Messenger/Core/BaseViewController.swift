import SwiftUI

public protocol BaseViewControllerProtocol: UIViewController {
    var onRemoveFromNavigationStack: (() -> Void)? { get set }
    var onDidDismiss: (() -> Void)? { get set }
}

open class BaseViewController: UIViewController, BaseViewControllerProtocol {
    public var onRemoveFromNavigationStack: (() -> Void)?
    public var onDidDismiss: (() -> Void)?
//    var bag = Bag()
    
    override public func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            onRemoveFromNavigationStack?()
        }
    }
    
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag) { [weak self] in
            completion?()
            self?.onDidDismiss?()
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

extension BaseViewController {
    func setupNavBar() {
    }
}

@objc extension BaseViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
    }
    
    func navBarLeftButtonHandler() {
        navigationController?.popViewController(animated: true)
    }
    func navBarRightButtonHandler() {}
}
