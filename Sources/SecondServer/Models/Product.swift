import Fluent
import FluentKit
import Vapor

final class Product: Model, Content {
    static let schema = "products"

    // String primary key in 'code' column
    @ID(custom: "code", generatedBy: .user)
    var id: String?

    // Store the raw JSONB payload
    @Field(key: "doc")
    var doc: JSON

    init() { }

    init(code: String, doc: JSON) {
        self.id = code
        self.doc = doc
    }
}
