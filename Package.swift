// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    dependencies: [
         .package(url: "https://github.com/apple/swift-algorithms.git", from: "0.2.1"),
         .package(url: "https://github.com/apple/swift-async-algorithms.git", from: "0.0.3"),
//         .package(url: "https://github.com/apple/swift-collections.git", from: "0.0.7"),
//         .package(url: "https://github.com/apple/swift-numerics.git", from: "0.1.0"),
         .package(url: "https://github.com/pointfreeco/swift-parsing.git", from: "0.3.1"),
    ],
    targets: [
        .target(name: "AoC-2022",
                dependencies: [
                    .target(name: "Utils"),
                    .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                ],
                path: "Sources/2022",
                swiftSettings: [.unsafeFlags(["-enable-bare-slash-regex"])]),
        .testTarget(name: "AoC-2022-Tests",
                    dependencies: ["AoC-2022"],
                    path: "Tests/2022",
                    resources: (1...25).map { .copy("Resources/2022_day\($0).txt") }),

        .target(name: "AoC-2021",
                dependencies: [
                    .target(name: "Utils"),
                    .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                    .product(name: "Parsing", package: "swift-parsing"),
                ],
                path: "Sources/2021",
                swiftSettings: [.unsafeFlags(["-enable-bare-slash-regex"])]),
        .testTarget(name: "AoC-2021-Tests",
                    dependencies: ["AoC-2021"],
                    path: "Tests/2021",
                    resources: (1...25).map { .copy("Resources/2021_day\($0).txt") }),

        .target(name: "AoC-2020",
                dependencies: [
                    .target(name: "Utils"),
                    .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                ],
                path: "Sources/2020",
                swiftSettings: [.unsafeFlags(["-enable-bare-slash-regex"])]),
        .testTarget(name: "AoC-2020-Tests",
                    dependencies: ["AoC-2020"],
                    path: "Tests/2020",
                    resources: (1...25).map { .copy("Resources/2020_day\($0).txt") }),

        .target(name: "Utils",
                dependencies: [
                    .product(name: "Algorithms", package: "swift-algorithms")
                ]),
    ]
)
