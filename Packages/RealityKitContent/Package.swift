// swift-tools-version:6.2

import PackageDescription

let package = Package(
  name: "RealityKitContent",
  platforms: [
    .macOS(.v15)
  ],
  products: [
    .library(
      name: "RealityKitContent",
      targets: ["RealityKitContent"]
    )
  ],
  dependencies: [],
  targets: [
    .target(
      name: "RealityKitContent",
      dependencies: []
    )
  ]
)
