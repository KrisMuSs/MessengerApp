
import Foundation
import Firebase

struct FirestoreConstants {
    static let UserCollections = Firestore.firestore().collection("users")
    static let MessageCollection = Firestore.firestore().collection("messages")
}
