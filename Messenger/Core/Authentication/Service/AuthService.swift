

import Foundation
import Firebase
import FirebaseAuth

class AuthService{
    func login(withEmail email: String, password: String) async throws {
        print("DEBUG: Email is \(email)")
        print("DEBUG: Password is \(password)")
    }
    
    func createUser(withEmail email: String, password: String, fullName: String) async throws {
        do {
            // Попытка создать пользователя в Firebase с указанным email и паролем
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            // Печать UID нового пользователя, если все прошло успешно
            print("DEBUG: Create user \(result.user.uid)")
        } catch {
            print("DEBUG: Не удалось создать пользователя с ошибкой: \(error.localizedDescription)")
        }
    }
}

