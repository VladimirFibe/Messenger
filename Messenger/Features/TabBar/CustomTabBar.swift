import UIKit

final class CustomTabBar: UITabBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomTabBar {
    private func setup() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true
        layer.cornerRadius = 15
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
}
