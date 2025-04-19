import Vapor
import Fluent

func routes(_ app: Application) throws {
    // GET /product/:code
    app.get("product", ":code") { req async throws -> Product in
        guard let code = req.parameters.get("code"),
              let product = try await Product.find(code, on: req.db) else {
            let param = req.parameters.get("code") ?? "<nil>"
            throw Abort(.notFound, reason: "Product with code \(param) not found")
        }
        return product
    }

    // (Optional) simple health check
    app.get("health") { _ in "✅ OK" }
}
