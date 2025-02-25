
import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService{
    
    // Переменная для отслеживания зашел ли пользователь в систему
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    
    // Auth.auth().currentUser - строка возвращает текущего аутентифицированного
    // пользователя из Firebase, если он есть. Если пользователь авторизован, будет возвращен объект FirebaseAuth.User.
    
    // self.userSession = Auth.auth().currentUser - строка сохраняет текущего пользователя в
    // переменную userSession. Если пользователь был авторизован, она будет содержать объект User, если нет — nil.
    
    init(){
        // Перенаправляет пользователя на нужную страницу
        self.userSession = Auth.auth().currentUser
        loadCurrentUserData()
        print("DEBUG: User session id is \(userSession?.uid)")
    }
    
    @MainActor // Для работы с асинхронными функциями ожидания.
    // Гарантирует, что обновления после работы асинхронного ожидания выполняются в главном потоке
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            loadCurrentUserData()
        } catch {
            print("DEBUG: Failed to sign in user with error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            // Попытка создать пользователя в Firebase с указанным email и паролем
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            loadCurrentUserData()
            try await self.uploadUserData(email: email, fullname: fullname, id: result.user.uid)
        } catch {
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() // эта строка выводит пользователя из системы на сервере
            // Сбрасываем сессию и данные, так как это свойство отвечает за отображение пользователю нужной страницы: входа или главного экрана
            self.userSession = nil
            // Точно удаляем информацию о прошлом пользователе
            UserService.shared.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    // Этот метод загрузит информацию о нашем пользователе и сохранит ее в firebase
    private func uploadUserData(email: String, fullname: String, id: String) async throws {
        let user = User(fullname: fullname, email: email, profileImageUrl: nil)
        guard let encoderUser = try? Firestore.Encoder().encode(user) else { return }
        try await Firestore.firestore().collection("users").document(id).setData(encoderUser)
    }
    
    // Эта функция поможет избавиться от остатков прошлого пользователя в системе и загрузить нового
    private func loadCurrentUserData() {
        // Получаем информацию о пользователе сохраненную в Firebase
        Task { try await UserService.shared.fetchCurrentUser() }
    }
}

