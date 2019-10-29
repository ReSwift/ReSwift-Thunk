// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "ReSwiftThunk",
    products: [
      .library(name: "ReSwiftThunk", targets: ["ReSwiftThunk"])
    ],
    dependencies: [
      .package(url: "https://github.com/ReSwift/ReSwift", .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
      .target(
        name: "ReSwiftThunk",
        dependencies: [
          "ReSwift"
        ],
        path: "ReSwift-Thunk"
      )
    ]
)
