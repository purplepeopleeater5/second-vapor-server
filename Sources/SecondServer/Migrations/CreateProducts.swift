import Fluent
import SQLKit

struct CreateProducts: AsyncMigration {
    func prepare(on database: any Database) async throws {
        // Create table
        try await database.schema("products")
            .field("code", .string, .identifier(auto: false))
            .field("doc",  .custom("jsonb"), .required)
            .create()

        // Create GIN index via SQLKit
        let sqlDb = database as! SQLDatabase
        try await sqlDb.raw("""
            CREATE INDEX IF NOT EXISTS idx_products_doc
              ON products USING GIN (doc jsonb_path_ops)
            """).run()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("products").delete()
    }
}
