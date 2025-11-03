// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SimplePalet",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "SimplePalet",
            targets: ["SimplePalet"]
        )
    ],
    dependencies: [
        // 外部依存なし - CGEventTapを使用した独自実装
    ],
    targets: [
        .executableTarget(
            name: "SimplePalet",
            dependencies: [],
            path: "SimplePalet"
        )
    ]
)

