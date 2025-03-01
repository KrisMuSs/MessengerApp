

import Foundation
import Firebase
import FirebaseAuth

// Возможные сценарии обновления списка:
// Если кто-то напишет, то мы должны добавить его всписок разговров
// Если напишет собеседник, который уже писал, то его стоит удалить из списка и вывести в начало
// Если пользователь сам пишет кому-то, этот чат тоже должен подняться наверх списка


/// Этот класс наблюдает за последними сообщениями и обновляет список чатов в реальном времени
class InboxService {
    @Published var documentChanges = [DocumentChange]()
    
    
    func observeRecentMessage(){
       guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = FirestoreConstants
            .MessageCollection
            .document(uid)
            .collection("recent-messages")
            .order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { snapshot, _ in
            guard let changes = snapshot?.documentChanges.filter({
                $0.type == .added || $0.type == .modified
            }) else { return }
            
            self.documentChanges = changes

        }
        
    }
}
