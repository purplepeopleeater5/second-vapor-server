import Vapor                                                   // Application, Environment, Response, HTTPHeaders, etc. :contentReference[oaicite:8]{index=8}
import Fluent                                                  // core Fluent types :contentReference[oaicite:9]{index=9}
import FluentPostgresDriver                                    // Postgres driver for Fluent :contentReference[oaicite:10]{index=10}
import Leaf                                                    // Leaf view renderer :contentReference[oaicite:11]{index=11}

public func configure(_ app: Application) async throws {
    // ─── File Middleware ────────────────────────────────────────────────────────
    // Serve files from /Public directory (e.g. CSS, JS, images)
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))  // :contentReference[oaicite:12]{index=12}

    // ─── Database Configuration ────────────────────────────────────────────────
    if let databaseURL = Environment.get("DATABASE_URL") {
        // Use URL‑based initializer for cloud databases
        try app.databases.use(.postgres(url: databaseURL), as: .psql)               // :contentReference[oaicite:13]{index=13}
    } else {
        // Fallback to manual host/port config for local development
        let hostname = Environment.get("DATABASE_HOST") ?? "localhost"
        let port     = Environment.get("DATABASE_PORT").flatMap(Int.init(_:))
                       ?? SQLPostgresConfiguration.ianaPortNumber                   // :contentReference[oaicite:14]{index=14}
        let username = Environment.get("DATABASE_USERNAME") ?? "tannerbennett"
        let password = Environment.get("DATABASE_PASSWORD") ?? ""
        let database = Environment.get("DATABASE_NAME") ?? "openfoodfacts"

        let sqlConfig = SQLPostgresConfiguration(
            hostname: hostname,
            port: port,
            username: username,
            password: password,
            database: database,
            tls: .disable                                                           // disable TLS locally; switch to .prefer in production :contentReference[oaicite:15]{index=15}
        )
        app.databases.use(.postgres(configuration: sqlConfig), as: .psql)
    }

    // ─── Migrations ─────────────────────────────────────────────────────────────
    // Keep your existing migrations (e.g. CreateTodo)
    app.migrations.add(CreateTodo())
    #if DEBUG
    // Automatically run pending migrations in debug builds
    try await app.autoMigrate()                                                   // :contentReference[oaicite:16]{index=16}
    #endif

    // ─── Leaf Views ────────────────────────────────────────────────────────────
    // Render Leaf templates for your web frontend
    app.views.use(.leaf)                                                           // :contentReference[oaicite:17]{index=17}

    // ─── Routes ────────────────────────────────────────────────────────────────
    try routes(app)                                                                // define your HTTP routes in routes.swift :contentReference[oaicite:18]{index=18}
}
