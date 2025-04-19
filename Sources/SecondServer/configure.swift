import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

public func configure(_ app: Application) async throws {
    // MARK: – Database
    let hostname = Environment.get("DATABASE_HOST") ?? "localhost"
    let port = Environment.get("DATABASE_PORT").flatMap(Int.init)
                ?? SQLPostgresConfiguration.ianaPortNumber
    let username = Environment.get("DATABASE_USERNAME") ?? "vapor_username"
    let password = Environment.get("DATABASE_PASSWORD") ?? "vapor_password"
    let database = Environment.get("DATABASE_NAME") ?? "vapor_database"

    // For local dev, disable TLS; enable it in prod if you need SSL
    app.databases.use(.postgres(
        hostname: hostname,
        port: port,
        username: username,
        password: password,
        database: database,
        tls: .disable
    ), as: .psql)

    // MARK: – Migrations
    app.migrations.add(CreateProducts())

    #if DEBUG
    try await app.autoMigrate()
    #endif

    // MARK: – Views
    app.views.use(.leaf)

    // MARK: – Routes
    try routes(app)
}
