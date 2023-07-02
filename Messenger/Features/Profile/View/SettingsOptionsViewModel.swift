import SwiftUI

enum SettingsOptionsViewModel: Int, CaseIterable, Identifiable {
    case darkMode
    case status
    case accessibility
    case privacy
    case notifications
    
    var title: String {
        switch self {
        case .darkMode: return "Dark mode"
        case .status: return "Active Status"
        case .accessibility: return "Accessibility"
        case .privacy: return "Privacy and Safety"
        case .notifications: return "Notifications"
        }
    }
    
    var image: String {
        switch self {
        case .darkMode: return "moon.circle.fill"
        case .status: return "message.badge.circle.fill"
        case .accessibility: return "person.circle.fill"
        case .privacy: return "lock.circle.fill"
        case .notifications: return "bell.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .darkMode: return .black
        case .status: return .green
        case .accessibility: return .black
        case .privacy: return .blue
        case .notifications: return .purple
        }
    }
    var id: Int { self.rawValue }
}
