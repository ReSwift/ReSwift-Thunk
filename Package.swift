// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "ReSwift-Thunk",
    products: [
      .library(name: "ReSwift-Thunk", targets: ["ReSwift-Thunk"])
    ],
    dependencies: [
      .package(url: "https://github.com/ReSwift/ReSwift", .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
      .target(
        name: "ReSwift-Thunk",
        dependencies: [
          "ReSwift"
        ],
        path: "ReSwift-Thunk"
      )
    ]
)
