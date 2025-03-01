
import Foundation

// Будем использовать маршрут для навигации (перехода) между профилем или чатом
enum Route: Hashable {
    case profile(User)
    case chatView(User)
}

