import Foundation

public final class AoC_2021_Day7 {
    let positions: [Int]

    public init(_ inputFileURL: URL) throws {
        positions = try String(contentsOf: inputFileURL)
            .trimmingCharacters(in: .newlines)
            .split(separator: ",")
            .map(String.init)
            .compactMap(Int.init)
    }

    public func solvePart1() async throws -> Int {
        try await solve { $0 }
    }

    public func solvePart2() async throws -> Int {
        try await solve { n in
            n * (n + 1) / 2
        }
    }

    private func solve(transform: (Int) -> Int) async throws -> Int {
        (1 ..< positions.count)
            .map { destination in
                positions
                    .map { abs(destination - $0) }
                    .map(transform)
                    .reduce(0, +)
            }
            .min()!
    }
}
