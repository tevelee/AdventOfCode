import Foundation
import Algorithms
import AsyncAlgorithms

public final class AoC_2022_Day1 {
    let input: String

    public init(_ inputFileURL: URL) throws {
        input = try String(contentsOf: inputFileURL)
    }

    public init(_ input: String) {
        self.input = input
    }

    public func solvePart1() -> Int {
        input.paragraphs
            .map { $0.compactMap(Int.init).sum() }
            .max() ?? 0
    }

    public func solvePart2() -> Int {
        input.paragraphs
            .map { $0.compactMap(Int.init).sum() }
            .max(count: 3)
            .sum()
    }
}
