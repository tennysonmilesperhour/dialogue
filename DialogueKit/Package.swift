// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DialogueKit",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "DialogueKit", targets: ["DialogueKit"])
    ],
    targets: [
        .target(name: "DialogueKit"),
        .testTarget(name: "DialogueKitTests", dependencies: ["DialogueKit"]),
    ]
)
