

import SwiftUI

// ObservableObject — этот протокол позволяет отслеживать изменения данных и
// обновлять View, когда изменяются свойства, помеченные @Published

class RegistrationViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""

    func createUser() async throws{
        // Вызываем вход пользователя и передаем email, пароль и полное имя
        try await AuthService().createUser(withEmail: email, password: password, fullName: fullname)
    }
    
}
