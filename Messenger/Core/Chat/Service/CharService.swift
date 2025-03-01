

import Foundation
import FirebaseAuth
import Firebase

struct ChatService {
    
    static let messagesCollection = Firestore.firestore().collection("messages")
    
    let chatPartner: User
    
     func sendMessage(_ messageText: String) {
        guard let currentUId = Auth.auth().currentUser?.uid else { return }
        // chatPartnerId - человек, с которым мы разговариваем
        let chatPartnerId = chatPartner.id
        
        let currentUserRef = FirestoreConstants.MessageCollection.document(currentUId).collection(chatPartnerId).document()
        let chatPartnerRef = FirestoreConstants.MessageCollection.document(chatPartnerId).collection(currentUId)
         
         let recentCurrentUserRef = FirestoreConstants.MessageCollection.document(currentUId).collection("recent-messages").document(chatPartnerId)
         
         let recentPartnerRef = FirestoreConstants.MessageCollection.document(chatPartnerId).collection("recent-messages").document(currentUId)
        
        let messageId = currentUserRef.documentID
        
        let message = Message(
            messageId: messageId, // Id беседы
            fromId: currentUId, // Отправитель
            toId: chatPartnerId, // Получатель
            messageText: messageText,
            timestamp: Timestamp()) // Метка времени
        guard let messageData = try? Firestore.Encoder().encode(message) else { return }
        
        currentUserRef.setData(messageData)
        chatPartnerRef.document(messageId).setData(messageData)
         
        recentCurrentUserRef.setData(messageData)
        recentPartnerRef.setData(messageData)

    }
    
    
    // Мы не используем async await, потому что нам требуется addSnapshotListener
      func observeMessage(completion: @escaping([Message]) -> Void){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
         let chatPartnerId = chatPartner.id
         
         // Зайди в раздел сообщений (messages)
        let query = FirestoreConstants.MessageCollection
         // перейди к текущему пользователю
                    .document(currentUid)
         // затем на id его собеседника
                    .collection(chatPartnerId)
         // затем отсортируем их по времени отправки ( т.е нам не надо делать фильтрацию самому, у Firebase имеется своя фкнкция сортировки
                    .order(by: "timestamp", descending: false)
         
         /* Этот метод добавляет слушателя изменений (listener), который автоматически вызывается при любом изменении данных в Firestore
          Если собеседник отправляет сообщение из другого устройства, Firestore также фиксирует изменение, а наш слушатель моментально его получает. После добавления сообщения в бд, мы моментально отображаем его на телефоне. Это дает эффект живого чата*/
         
         query.addSnapshotListener{ snapshot, _ in
             // есть разные типы изменений документа .added, .modified, removed, но мы хотим получать информацию, как только сообщение
             // добавляется в коллекцию
             guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
             // Декадируем входящие данные в messages
             var messages = changes.compactMap({ try? $0.document.data(as: Message.self)})
             
             // Этот цикл for проходит по всем сообщениям в массиве messages, добавляя информацию о пользователе (chatPartner) только к сообщениям, отправленным собеседником
             
             for (index, message) in messages.enumerated() where message.fromId != currentUid {
                 messages[index].user = chatPartner
             }
             
             // Это механизм передачи новых сообщений в вызывающий код (в observeMessages в классе MessageService). Без completion, observeMessage просто загружала бы сообщения, но нигде их не показывал.
             completion(messages)
         }
    }
    
}
