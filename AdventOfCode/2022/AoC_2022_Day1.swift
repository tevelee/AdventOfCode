import Foundation
import Algorithms

public final class AoC_2022_Day1 {
    let input: Input

    public init(_ input: Input) {
        self.input = input
    }

    public func solvePart1() throws -> Int {
        try input.wholeInput.paragraphs
            .map { $0.compactMap(Int.init).sum() }
            .max() ?? 0
    }

    public func solvePart2() throws -> Int {
        try input.wholeInput.paragraphs
            .map { $0.compactMap(Int.init).sum() }
            .max(count: 3)
            .sum()
    }
}
