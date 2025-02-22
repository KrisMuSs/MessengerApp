
import SwiftUI

// ObservableObject — этот протокол позволяет отслеживать изменения данных и
// обновлять View, когда изменяются свойства, помеченные @Published

class LoginViewModel: ObservableObject{
    
    @Published var email = ""
    @Published var password = ""

    func login() async throws{
        // Вызываем вход пользователя и передаем email и пароль
        try await AuthService.shared.login(withEmail: email, password: password)
    }
    
}
