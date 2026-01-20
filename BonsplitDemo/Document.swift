import Foundation

@Observable
class Document: Identifiable {
    let id: UUID
    var title: String
    var content: String
    var isDirty: Bool

    init(id: UUID = UUID(), title: String = "Untitled", content: String = "", isDirty: Bool = false) {
        self.id = id
        self.title = title
        self.content = content
        self.isDirty = isDirty
    }
}
