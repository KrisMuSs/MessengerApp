
import Foundation
import Combine
import Firebase

/// Этот класс отслеживает изменения информации о пользователе и обновляет интерфейс при их появлении
class InboxViewModel: ObservableObject{
    @Published var currentUser: User?
    @Published var recentMessages = [Message]()
    @Published var isNotRead = [String: Bool]()
    
    @Published var selectedUserVM: User? // Добавляем сюда
    
    // Для обновления активных пользователей
    private var activeNowViewModel = ActiveNowViewModel()

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
                
                print("DEBUG: Проверяем работает ли функция selectedUser = \(String(describing: selectedUserVM?.id)) и message.chatPartnerId = \(message.chatPartnerId)")

                // Проверяем, не открыт ли уже чат с этим пользователем
                            if selectedUserVM?.id == message.chatPartnerId {
                                // Если чат открыт, не меняем статус непрочитанности
                                print("DEBUG: Функция работает")

                                continue
                            }
                
                
                // Находим старое сообщение этого пользователя, если оно уже есть в списке
                if let index = recentMessages.firstIndex(where: { $0.chatPartnerId == message.chatPartnerId }) {
                    // Удаляем старое сообщение этого пользователя
                    recentMessages.remove(at: index)
                    
                    // Система непрочитанных сообщений
                   // message.isNotRead = true
                    //isNotReadPartner = true
                    
                     isNotRead[message.chatPartnerId] = true
                    
                    // Проверяем, если текущий чат уже открыт с этим пользователем, не обновляем статус
                    

                               
                    
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

    // Метод для сброса статуса непрочитанного сообщения
        func markMessageAsRead(for chatPartnerId: String) {
            isNotRead[chatPartnerId] = false
        }
    

       func updateSelectedUserFull(_ user: User?) {
           print("DEBUG: Метод сработал selectedUserVM = \(String(describing: selectedUserVM?.id))")
           self.selectedUserVM = user
       }
    
    func updateSelectedUserUnFull(_ user: User?) {
        print("DEBUG: Метод занулил selectedUserVM = \(String(describing: selectedUserVM?.id))")
        self.selectedUserVM = nil
    }
    
    @MainActor
       func refreshActiveUsers() async {
           // Обновляем активных пользователей при потягивании экрана
           do {
               try await activeNowViewModel.fetchUsers()
           } catch {
               print("Failed to refresh active users: \(error)")
           }
       }
    
}
