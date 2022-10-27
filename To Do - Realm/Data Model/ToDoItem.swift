import Foundation
import RealmSwift

class ToDoItem: Object {
    @objc dynamic var textToDo: String = ""
    @objc dynamic var createdAt: Date = Date()
}
