// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .executable(name: "FetchEvents", targets: ["FetchEvents"]),
    ],
    dependencies: [
         .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.0"),
         .package(url: "https://github.com/apple/swift-async-algorithms.git", from: "1.0.0-beta.1"),
         .package(url: "https://github.com/apple/swift-collections.git", branch: "release/1.1"),
         .package(url: "https://github.com/apple/swift-testing.git", branch: "main"),
//         .package(url: "https://github.com/apple/swift-numerics.git", from: "1.0.2"),
         .package(url: "https://github.com/davecom/SwiftGraph.git", from: "3.1.0"),
         .package(url: "https://github.com/pointfreeco/swift-parsing.git", from: "0.3.1"),
         .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
         .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.4.3"),
    ],
    targets: [
        .target(
            name: "AoC-2023",
            dependencies: [
                .target(name: "Utils"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ],
            path: "Sources/2023",
            exclude: ["Tasks"],
            swiftSettings: [.unsafeFlags(["-enable-bare-slash-regex"])]
        ),
        .testTarget(
            name: "AoC-2023-Tests",
            dependencies: ["AoC-2023", .product(name: "Testing", package: "swift-testing")],
            path: "Tests/2023",
            resources: (1...25).map { .copy("Resources/2023_day\($0).txt") }
        ),

        .target(
            name: "AoC-2022",
            dependencies: [
                .target(name: "Utils"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ],
            path: "Sources/2022",
            exclude: ["Tasks"],
            swiftSettings: [.unsafeFlags(["-enable-bare-slash-regex"])]
        ),
        .testTarget(
            name: "AoC-2022-Tests",
            dependencies: ["AoC-2022"],
            path: "Tests/2022",
            resources: (1...25).map { .copy("Resources/2022_day\($0).txt") }
        ),

        .target(
            name: "AoC-2021",
            dependencies: [
                .target(name: "Utils"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                .product(name: "Parsing", package: "swift-parsing"),
            ],
            path: "Sources/2021",
            exclude: ["Tasks"],
            swiftSettings: [.unsafeFlags(["-enable-bare-slash-regex"])]
        ),
        .testTarget(
            name: "AoC-2021-Tests",
            dependencies: ["AoC-2021"],
            path: "Tests/2021",
            resources: (1...25).map { .copy("Resources/2021_day\($0).txt") }
        ),

        .target(
            name: "AoC-2020",
            dependencies: [
                .target(name: "Utils"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ],
            path: "Sources/2020",
            exclude: ["Tasks"],
            swiftSettings: [.unsafeFlags(["-enable-bare-slash-regex"])]
        ),
        .testTarget(
            name: "AoC-2020-Tests",
            dependencies: ["AoC-2020"],
            path: "Tests/2020",
            resources: (1...25).map { .copy("Resources/2020_day\($0).txt") }
        ),

        .target(
            name: "Utils",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "SwiftGraph", package: "SwiftGraph")
            ]
        ),

        .executableTarget(
            name: "FetchEvents",
            dependencies: [
                .product(name: "SwiftSoup", package: "SwiftSoup"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
    ]
)
