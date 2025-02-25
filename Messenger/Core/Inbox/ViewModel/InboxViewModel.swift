
import Foundation
import Combine
import Firebase

// Он отслеживает изменения информации о пользователе и обновляет интерфейс при их появлении
class InboxViewModel: ObservableObject{
    @Published var currentUser: User?
    
    // Переменная для хранения ссылок на активные процессы, которые следят за изменениями
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    // Метод настраивает наблюдение за изменениями в userSession
    private func setupSubscribers() {
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
        
    }
}
