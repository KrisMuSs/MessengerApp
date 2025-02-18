

import SwiftUI

enum SettingOptionsViewModel: Int, CaseIterable, Identifiable{
    case darkMode
    case activeStatus
    case accessibility
    case privacy
    case notification
    
    var title: String {
        switch self {
        case .darkMode: return "Dark mode"
        case .activeStatus: return "Active status"
        case .accessibility: return "Accessibility"
        case .privacy: return "Privacy and Safety"
        case .notification: return "Notification"
        }
    }
    
    var imageName: String {
        switch self {
        case .darkMode: return "moon.circle.fill"
        case .activeStatus: return "message.badge.circle.fill"
        case .accessibility: return "person.circle.fill"
        case .privacy: return "lock.circle.fill"
        case .notification: return "bell.circle.fill"
        }
    }
    
    var imageBackgroundColor: Color {
        switch self {
        case .darkMode: return Color.black
        case .activeStatus: return Color(.systemGreen)
        case .accessibility: return Color.black
        case .privacy: return Color(.systemBlue)
        case .notification: return Color(.systemPurple)
        }
    }
    // Нужен, чтобы перебирать эту структуру данных, просматривать каждый случай и присваивать id, чтобы swiftui
    // мог различать эти представления

    // Каждый кейс хранит значение. darkMode = 0, activeStatus = 1 это нужно для перебора этой структуры данных, присваивать
    // ему идентификатор и перебирать, чтобы swiftui мог различать это представление.
    var id: Int { return self.rawValue }
}


