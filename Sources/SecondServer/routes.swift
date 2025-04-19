import Vapor
import Fluent

func routes(_ app: Application) throws {
    // GET /product/:code
    app.get("product", ":code") { req async throws -> Product in
        guard let code = req.parameters.get("code"),
              let product = try await Product.find(code, on: req.db) else {
            let missing = req.parameters.get("code") ?? "<nil>"
            throw Abort(.notFound, reason: "Product with code \(missing) not found")
        }
        return product
    }

    // (Optional) Health check
    app.get("health") { _ in "✅ OK" }
}
