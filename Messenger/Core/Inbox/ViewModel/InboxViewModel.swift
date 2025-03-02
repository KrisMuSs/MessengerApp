
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
       // Подписка позволяет обновлять информацию о текущем пользователе, когда она изменяется, и обновлять состояние currentUser
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
        
        //Подписка позволяет отслеживать изменения в списке сообщений и автоматически обновлять состояние recentMessages, когда появляются новые сообщения или изменяются существующие
        service.$documentChanges.sink { [weak self] changes in
            self?.loadInditialessages(fromChanges: changes)
        }.store(in: &cancellables)
        
    }
    /// Загружает и обновляет список сообщений, добавив информацию о собеседнике для каждого сообщения
    private func loadInditialessages(fromChanges changes: [DocumentChange]) {
        // Вернет нам текст и время отправки сообщения, но не вернет данные пользователя
        var messages = changes.compactMap({ try? $0.document.data(as: Message.self) })
        
        // Если сообщения есть, обрабатываем
        if !messages.isEmpty {
            for i in 0 ..< messages.count {
                let message = messages[i]
                
                // Находим старое сообщение этого пользователя, если оно уже есть в списке
                if let index = recentMessages.firstIndex(where: { $0.chatPartnerId == message.chatPartnerId }) {
                    // Удаляем старое сообщение этого пользователя
                    recentMessages.remove(at: index)
                }
                
                // Возвращаем пользователя для текущего сообщения
                UserService.fetchUser(withUid: message.chatPartnerId) { user in
                    messages[i].user = user
                    // Добавляем новое сообщение в список recentMessages
                    self.recentMessages.append(messages[i])
                    
                    // Сортируем список по времени (от нового к старому)
                    self.recentMessages.sort { $0.timestamp.compare($1.timestamp) == .orderedDescending }
                }
            }
        }
    }

    
}
