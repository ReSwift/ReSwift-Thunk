// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "ReSwift-Thunk",
    products: [
      .executable(name: "ReSwift-Thunk", targets: ["ReSwift-Thunk"])
    ],
    dependencies: [
      .package(url: "https://github.com/ReSwift/ReSwift", .upToNextMajor(from: "4.1.1"))
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
