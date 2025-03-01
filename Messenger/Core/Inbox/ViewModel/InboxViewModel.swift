
import Foundation
import Combine
import Firebase

/// Этот класс отслеживает изменения информации о пользователе и обновляет интерфейс при их появлении
class InboxViewModel: ObservableObject{
    @Published var currentUser: User?
    @Published var recentMessages = [Message]()

    /// Переменная для хранения ссылок на активные процессы, которые следят за изменениями
    private var cancellables = Set<AnyCancellable>()
    
    private let service = InboxService()
    
    init() {
        setupSubscribers()
        service.observeRecentMessage()
    }
    
    // Метод настраивает наблюдение за изменениями в userSession
    private func setupSubscribers() {
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
        
        service.$documentChanges.sink { [weak self] changes in
            self?.loadInditialessages(fromChanges: changes)
        }.store(in: &cancellables)
        
    }
    
    private func loadInditialessages(fromChanges changes: [DocumentChange]) {
        // Вернет нам текст и время отправки сообщения, но не вернет данные пользователя
        var messages = changes.compactMap({ try? $0.document.data(as: Message.self) })
        
        for i in 0 ..< messages.count{
            let message = messages[i]
            
            // возвращаем пользователя
            UserService.fetchUser(withUid: message.chatPartnerId) { user in
                messages[i].user = user
                // Добавляем его в список recentMessages. Теперь у нас есть текст, время отправки и пользователь
                self.recentMessages.append(messages[i])
            }
        }
    }
    
}
