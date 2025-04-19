import Vapor
import SQLKit  // gives us SQLDatabase & raw(...)

func routes(_ app: Application) throws {
    // GET /product/:code → returns the raw JSONB payload
    app.get("product", ":code") { req async throws -> Response in
        guard let code = req.parameters.get("code") else {
            throw Abort(.badRequest, reason: "Missing barcode")
        }

        // Cast to SQLDatabase so we can run raw SQL
        let sqlDb = req.db as! SQLDatabase

        // Query JSONB column, cast to text
        let rows = try await sqlDb.raw(
            "SELECT doc::text AS json FROM products WHERE code = $1",
            [code]
        ).all()

        guard let jsonValue = rows.first?.column("json")?.string else {
            throw Abort(.notFound, reason: "No product with code \(code)")
        }

        // Build a Vapor response with application/json
        var res = Response(status: .ok)
        res.headers.replaceOrAdd(name: .contentType, value: "application/json")
        res.body = .init(string: jsonValue)
        return res
    }

    // simple health‑check
    app.get("health") { _ in "✅ OK" }
}
