import Fluent
import FluentKit
import Vapor

final class Product: Model, Content {
    static let schema = "products"

    @ID(custom: "code", generatedBy: .user)
    var id: String?

    @Field(key: "doc")
    var doc: JSON

    init() { }

    init(code: String, doc: JSON) {
        self.id = code
        self.doc = doc
    }
}

// Allow mutable properties in a Sendable class
extension Product: @unchecked Sendable { }
