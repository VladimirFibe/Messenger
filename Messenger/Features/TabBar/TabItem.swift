import Foundation

enum TabItem: Int {
    case inbox
    case profile
    
    var icon: String {
        switch self {
        case .inbox: return "bubble.left.fill"
        case .profile: return "person"
        }
    }
}
