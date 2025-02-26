
import Foundation
import FirebaseFirestore
import FirebaseAuth

struct Message: Identifiable, Codable, Hashable {
    // Id сомого чата двух пользователей
    @DocumentID var messageId: String?
    let fromId: String
    let toId: String
    let messageText: String
    let timestamp: Timestamp
    
    var user: User?
    
    var id: String {
        return messageId ?? UUID().uuidString
    }
    
    var chatPartnerId: String {
        // Мы говорим, что если идентификатор отправителя равен идентификатору currentUser, то toId иначе fromId
        // Помогает понять с кем мы разговариваем
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
    // Для логики помогающий нам определить, от кого пришло сообщение, от нас или собеседника
    var isFromCurrentUser: Bool {
        return fromId == Auth.auth().currentUser?.uid
    }
}

