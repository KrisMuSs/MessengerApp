

import Foundation

struct User: Codable, Identifiable, Hashable{
    var id = UUID().uuidString
    var fullname: String
    var email: String
    var profileImageUrl: String?
}

extension User {
    static let MOCK_USER = User(fullname: "Bruce Wayne", email: "batman@mail.ru", profileImageUrl: "batman")
}
