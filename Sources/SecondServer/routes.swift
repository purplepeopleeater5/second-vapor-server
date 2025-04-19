import Vapor           // for Application, Request, Response, Abort, etc.
import SQLKit          // for SQLDatabase, SQLRow

func routes(_ app: Application) throws {
    app.get("product", "search") { req async throws -> Response in
        // 1) Read the `name` query parameter: /product/search?name=apple
        guard let name = req.query[String.self, at: "name"]?
                .trimmingCharacters(in: .whitespaces),
              !name.isEmpty
        else {
            throw Abort(.badRequest,
                        reason: "You must provide a non‑empty `name` query parameter")
        }
        // 2) Downcast to the SQLDatabase protocol for raw queries
        let sqlDb = req.db as! any SQLDatabase

        // 3) Run raw SQL to filter JSONB: extract product_name via ->> and use ILIKE
        let rows = try await sqlDb.raw("""
            SELECT doc::text AS json
              FROM products
             WHERE doc->>'product_name' ILIKE '%' || \(bind: name) || '%'
            """
        ).all()  // returns [any SQLRow]

        // 4) If no rows found, return 404
        guard let row = rows.first else {
            throw Abort(.notFound,
                        reason: "No product found with name containing '\(name)'")
        }

        // 5) Decode the JSON string out of the row
        let jsonString = try row.decode(column: "json", as: String.self)

        // 6) Build and return the HTTP response
        var res = Response(status: .ok)
        res.headers.contentType = .json
        res.body = .init(string: jsonString)
        return res
    }
}
