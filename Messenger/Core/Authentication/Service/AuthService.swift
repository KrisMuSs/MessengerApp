
import Foundation
import FirebaseAuth

class AuthService{
    
    // Переменная для отслеживания зашел ли пользователь в систему
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    
    // Auth.auth().currentUser - строка возвращает текущего аутентифицированного
    // пользователя из Firebase, если он есть. Если пользователь авторизован, будет возвращен объект FirebaseAuth.User.
    
    // self.userSession = Auth.auth().currentUser - строка сохраняет текущего пользователя в
    // переменную userSession. Если пользователь был авторизован, она будет содержать объект User, если нет — nil.
    
    init(){
        self.userSession = Auth.auth().currentUser
        print("DEBUG: User session id is \(userSession?.uid)")
    }
    
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
        } catch {
            print("DEBUG: Failed to sign in user with error: \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullName: String) async throws {
        do {
            // Попытка создать пользователя в Firebase с указанным email и паролем
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user

        } catch {
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() // эта строка выводит пользователя из системы на сервере
            // Сбрасываем сессию и данные, так как это свойство отвечает за отображение пользователю нужной страницы: входа или главного экрана
            self.userSession = nil
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
}

