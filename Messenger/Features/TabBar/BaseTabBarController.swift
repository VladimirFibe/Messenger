import UIKit

class BaseTabBarController: UITabBarController, BaseViewControllerProtocol {
    var onRemoveFromNavigationStack: (() -> Void)?
    var onDidDismiss: (() -> Void)?
}
