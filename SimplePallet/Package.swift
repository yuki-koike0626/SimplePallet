// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SimplePallet",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "SimplePallet",
            targets: ["SimplePallet"]
        )
    ],
    dependencies: [
        // 外部依存なし - CGEventTapを使用した独自実装
    ],
    targets: [
        .executableTarget(
            name: "SimplePallet",
            dependencies: [],
            path: "SimplePallet"
        )
    ]
)

