import Vapor
import FluentPostgresDriver

public func configure(_ app: Application) async throws {
    // ← replace with your real DATABASE_URL or set as env
    let url = Environment.get("DATABASE_URL")
        ?? "postgresql://off:off@localhost:5432/openfoodfacts"

    // register Postgres via URL
    try app.databases.use(.postgres(url: url), as: .psql)

    // register your HTTP routes
    try routes(app)
}
