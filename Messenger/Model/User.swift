

import Foundation
import FirebaseFirestore

struct User: Codable, Identifiable, Hashable{
    
    // Firestore сам присваивает уникальный uid при добавлении объекта
    @DocumentID var uid: String?
    
    // Ранее вручную создавался "id", но это не нужно, так как Firestore сам генерирует "uid"
    // var id = UUID().uuidString
    var fullname: String
    var email: String
    var profileImageUrl: String?
    
    
    // id автоматически использует uid из Firestore
    // если оно не задано, создается случайный "UUID" (для безопасности)
    var id: String{
        return uid ?? UUID().uuidString
    }
    // извлекает имя из полного имени, с помощью специального инструмента из Foundation
    var firstName: String {
        let formatter = PersonNameComponentsFormatter()
        let components = formatter.personNameComponents(from: fullname)
        return components?.givenName ?? fullname
    }
    
}

extension User {
    static let MOCK_USER = User(fullname: "Bruce Wayne2", email: "batman@mail.ru", profileImageUrl: "batman")
}

