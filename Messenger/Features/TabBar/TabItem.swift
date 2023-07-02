import Foundation

enum TabItem: Int {
    case profile
    
    var icon: String {
        switch self {
        case .profile: return "person"
        }
    }
}
