// swift-tools-version:6.0
import PackageDescription

// Enable Swift’s upcoming features (if you need them)
var swiftSettings: [SwiftSetting] {
    [.enableUpcomingFeature("ExistentialAny")]
}

let package = Package(
    name: "SecondServer",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "SecondServer",
            targets: ["SecondServer"]
        )
    ],
    dependencies: [
        // Vapor web framework
        .package(url: "https://github.com/vapor/vapor.git", from: "4.110.1"),
        // Fluent ORM
        .package(url: "https://github.com/vapor/fluent.git", from: "4.9.0"),
        // Fluent Postgres driver
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.8.0"),
        // Leaf templating (if you use it)
        .package(url: "https://github.com/vapor/leaf.git", from: "4.3.0"),
        // Swift NIO core & posix
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
    ],
    targets: [
        .executableTarget(
            name: "SecondServer",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Leaf", package: "leaf"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "SecondServerTests",
            dependencies: [
                .target(name: "SecondServer"),
                .product(name: "XCTVapor", package: "vapor")
            ],
            swiftSettings: swiftSettings
        )
    ]
)
