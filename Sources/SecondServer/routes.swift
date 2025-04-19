import Vapor                         // brings in Application, Response, Abort, HTTPHeaders, etc. :contentReference[oaicite:0]{index=0}
import SQLKit                        // gives SQLDatabase, SQLRow, SQLExpression :contentReference[oaicite:1]{index=1}

func routes(_ app: Application) throws {
    app.get("product", ":code") { req async throws -> Response in
        // 1) Grab the code parameter
        let code = try req.parameters.require("code")

        // 2) Downcast to SQLDatabase – Swift 6 requires 'any' for protocol existentials :contentReference[oaicite:2]{index=2}
        let sqlDb = req.db as! any SQLDatabase

        // 3) Run a single-argument raw() with embedded bind to avoid injection :contentReference[oaicite:3]{index=3}
        let rows = try await sqlDb.raw("""
            SELECT doc::text AS json
              FROM products
             WHERE code = \(bind: code)
            """
        ).all()                                                      // returns [any SQLRow] :contentReference[oaicite:4]{index=4}

        // 4) Ensure we got something, else 404
        guard let row = rows.first else {
            throw Abort(.notFound,
                        reason: "No product with code '\(code)'")
        }

        // 5) Extract the JSON string – SQLRow.decode(column:as:) is the correct API :contentReference[oaicite:5]{index=5}
        let jsonString = try row.decode(column: "json", as: String.self)

        // 6) Build and return a proper JSON response
        var res = Response(status: .ok)
        res.headers.contentType = .json                              // set JSON content type :contentReference[oaicite:6]{index=6}
        res.body = .init(string: jsonString)
        return res
    }

    // Optional: a quick health‑check route
    app.get("health") { _ in "✅ OK" }
}
