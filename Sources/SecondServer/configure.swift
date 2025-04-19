import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

public func configure(_ app: Application) async throws {
    // Optional: serve /Public
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // ─── Database ─────────────────────────────────────────────────────────────
    let url = Environment.get("DATABASE_URL")
        ?? "postgresql://vapor_username:vapor_password@localhost:5432/vapor_database"
    try app.databases.use(.postgres(url: url), as: .psql)   // :contentReference[oaicite:0]{index=0}

    // ─── Migrations ────────────────────────────────────────────────────────────
    app.migrations.add(CreateProducts())
    #if DEBUG
    try await app.autoMigrate()
    #endif

    // ─── Views ─────────────────────────────────────────────────────────────────
    app.views.use(.leaf)

    // ─── Routes ────────────────────────────────────────────────────────────────
    try routes(app)
}
