import Fluent

struct CreateProducts: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("products")
            .field("code", .string, .identifier(auto: false))
            .field("doc",  .custom("jsonb"), .required)
            .create()
        // GIN index on JSONB
        try await database.raw(
            "CREATE INDEX IF NOT EXISTS idx_products_doc ON products USING GIN (doc jsonb_path_ops)"
        ).run()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("products").delete()
    }
}
