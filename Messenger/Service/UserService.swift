

import Foundation
import FirebaseAuth
import Firebase


/// Эта служба отвечает за получение всей информации из Firebase (служит для получения информации о пользователях, которые являются нашими контактами)
class UserService {
    @Published var currentUser: User?
    
    static let shared = UserService()
    
    @MainActor
   /// Загружаем данные пользователя из Firestore
    func fetchCurrentUser() async throws {
        // Убеждаемся, что у нас есть авторизованный пользователь, иначе останавливаем
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // Обращаемя к серверу Firebase, чтобы получить информацию о нашем пользователе
        let snaphot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        // Создаем объект user с помощью протокола Decodable
        let user = try snaphot.data(as: User.self)
        self.currentUser = user

    }
    /// Функция вернет всех пользователей (есть возможность указать лимит сколько пользователей вернуть)
    static func fetchAllUsers(limit: Int? = nil) async throws -> [User]{
        let query = FirestoreConstants.UserCollections
        if let limit { query.limit(to: limit) }
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        let users = snapshot.documents.compactMap({ try? $0.data(as: User.self ) })
        return users
    }
    
    // @escaping - загрузка данных из интернета занимает время, и функция завершится раньше, чем придут данные
    // @escaping означает, что completion будет вызван позже, когда данные действительно загрузятся
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        FirestoreConstants.UserCollections.document(uid).getDocument { snapshot, _ in // обращается к конкретному документу пользователя в Firestore
            guard let user = try? snapshot?.data(as: User.self) else { return } // преобразует данные в объект типа User
            completion(user) // возвращает полученного пользователя через замыкание (completion)
            }
        }
    }
    


