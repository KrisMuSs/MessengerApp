

import FirebaseAuth
import Combine

// Класс для сохранения входа пользователей в систему
class ContentViewModel: ObservableObject{
    
    // Переменная для отслеживания, авторизован ли пользователь
    @Published var userSession: FirebaseAuth.User?
    
    // Переменная для хранения ссылок на активные процессы, которые следят за изменениями
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    // Метод настраивает наблюдение за изменениями в userSession
    private func setupSubscribers() {
        AuthService.shared.$userSession.sink { [weak self] userSessionFromAuthService in
            self?.userSession = userSessionFromAuthService
        }.store(in: &cancellables)
        
    }
}
