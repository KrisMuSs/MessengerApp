
import Foundation
import FirebaseAuth

@MainActor
class NewMessageViewModel: ObservableObject {
    @Published var users = [User]()
    
    init() {
        Task { try await fetchUsers() }
    }
    
    func fetchUsers() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let users = try await UserService.fetchAllUsers()
        // Фильтруем массив, чтобы не получать в списке авторизованного пользователя
        self.users = users.filter({$0.id != currentUid })
    }
}
