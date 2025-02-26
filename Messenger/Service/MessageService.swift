

import Foundation
import FirebaseAuth
import Firebase

struct MessageService {
    
    static let messagesCollection = Firestore.firestore().collection("messages")
    
    static func sendMessage(_ messageText: String, toUser user: User) {
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        // chatPartnerId - человек, с которым мы разговариваем
        let chatPartnerId = user.id
        
        let currentUserRef = messagesCollection.document(currentId).collection(chatPartnerId).document()
        let chatPartnerRef = messagesCollection.document(chatPartnerId).collection(currentId)
        
        let messageId = currentUserRef.documentID
        
        let message = Message(
            messageId: messageId, // Id беседы
            fromId: currentId, // Отправитель
            toId: chatPartnerId, // Получатель
            messageText: messageText,
            timestamp: Timestamp()) // Метка времени
        guard let messageData = try? Firestore.Encoder().encode(message) else { return }
        
        currentUserRef.setData(messageData)
        chatPartnerRef.document(messageId).setData(messageData)
    }
    
    
}
