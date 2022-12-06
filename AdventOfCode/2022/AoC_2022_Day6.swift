import Foundation
import Algorithms

public final class AoC_2022_Day6 {
    let input: Input

    public init(_ input: Input) {
        self.input = input
    }

    public func solvePart1() throws -> Int {
        try findFirstDistinctCharacterWindow(in: input.wholeInput, size: 4)
    }

    public func solvePart2() throws -> Int {
        try findFirstDistinctCharacterWindow(in: input.wholeInput, size: 14)
    }

    private func findFirstDistinctCharacterWindow(in string: String, size: Int) -> Int {
        string
            .windows(ofCount: size)
            .first { characters in
                Set(characters).count == size
            }?
            .endIndex
            .utf16Offset(in: string) ?? 0
    }
}
