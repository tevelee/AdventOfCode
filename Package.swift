// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        .executable(name: "FetchEvents", targets: ["FetchEvents"]),
        .library(name: "AoC_2023", targets: ["AoC-2023"])
    ],
    dependencies: [
         .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.0"),
         .package(url: "https://github.com/apple/swift-async-algorithms.git", from: "1.0.0"),
         .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
         .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0"),
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
            swiftSettings: [.swiftLanguageMode(.v6), .define("ACCELERATE_NEW_LAPACK")]
        ),
        .testTarget(
            name: "AoC-2023-Tests",
            dependencies: ["AoC-2023"],
            path: "Tests/2023",
            resources: (1...25).map { .copy("Resources/2023_day\($0).txt") },
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),

        .target(
            name: "AoC-2022",
            dependencies: [
                .target(name: "Utils"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ],
            path: "Sources/2022",
            exclude: ["Tasks"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "AoC-2022-Tests",
            dependencies: ["AoC-2022"],
            path: "Tests/2022",
            resources: (1...25).map { .copy("Resources/2022_day\($0).txt") },
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),

        .target(
            name: "AoC-2021",
            dependencies: [
                .target(name: "Utils"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ],
            path: "Sources/2021",
            exclude: ["Tasks"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "AoC-2021-Tests",
            dependencies: ["AoC-2021"],
            path: "Tests/2021",
            resources: (1...25).map { .copy("Resources/2021_day\($0).txt") },
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),

        .target(
            name: "AoC-2020",
            dependencies: [
                .target(name: "Utils"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ],
            path: "Sources/2020",
            exclude: ["Tasks"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "AoC-2020-Tests",
            dependencies: ["AoC-2020"],
            path: "Tests/2020",
            resources: (1...25).map { .copy("Resources/2020_day\($0).txt") },
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),

        .target(
            name: "Utils",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                .product(name: "Collections", package: "swift-collections"),
                .target(name: "Graph")
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),

        .testTarget(
            name: "Utils-Tests",
            dependencies: ["Utils"],
            path: "Tests/Utils",
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),

        .target(
            name: "Graph",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Collections", package: "swift-collections"),
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),

        .testTarget(
            name: "Graph-Tests",
            dependencies: ["Graph"],
            path: "Tests/Graph",
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),

        .executableTarget(
            name: "FetchEvents",
            dependencies: [
                .product(name: "SwiftSoup", package: "SwiftSoup"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
    ]
)
