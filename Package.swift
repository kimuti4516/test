// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "StepPointLite",
    defaultLocalization: "ja",
    products: [
        .library(name: "StepPointLite", targets: ["StepPointLite"])
    ],
    targets: [
        .target(name: "StepPointLite", path: "Sources", resources: [.process("Resources")]),
        .testTarget(name: "StepPointLiteTests", dependencies: ["StepPointLite"], path: "Tests")
    ]
)
