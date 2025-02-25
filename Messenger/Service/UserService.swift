

import Foundation
import FirebaseAuth
import Firebase


// Эта служба будет отвечать за получение всей информации из Firebase ( будем получать информацию о пользователях, которые являются нашими контактами
class UserService {
    @Published var currentUser: User?
    
    static let shared = UserService()
    
    @MainActor
   // Загружаем данные пользователя из Firestore
    func fetchCurrentUser() async throws {
        // Убеждаемся, что у нас есть авторизованный пользователь, иначе останавливаем
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // Обращаемя к серверу Firebase, чтобы получить информацию о нашем пользователе
        let snaphot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        // Создаем объект user с помощью протокола Decodable
        let user = try snaphot.data(as: User.self)
        self.currentUser = user

    }
    // Функция вернет всех пользователей
    static func fetchAllUsers() async throws -> [User]{
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        let users = snapshot.documents.compactMap({ try? $0.data(as: User.self ) })
        return users
    }
}

