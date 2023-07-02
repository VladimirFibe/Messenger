import UIKit

class BaseTabBarController: UITabBarController, BaseViewControllerProtocol {
    var onRemoveFromNavigationStack: (() -> Void)?
    var onDidDismiss: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue(CustomTabBar().self, forKey: "tabBar")
    }
}
