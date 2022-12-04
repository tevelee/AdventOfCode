import Foundation
import RegexBuilder

public final class AoC_2022_Day4 {
    let input: Input

    public init(_ input: Input) {
        self.input = input
    }

    public func solvePart1() async throws -> Int {
        try await ranges()
            .filter { range1, range2 in
                range1.contains(range2) || range2.contains(range1)
            }
            .count
    }

    public func solvePart2() async throws -> Int {
        try await ranges()
            .filter { range1, range2 in
                range1.overlaps(range2)
            }
            .count
    }

    private func ranges() -> AnyAsyncSequence<(ClosedRange<Int>, ClosedRange<Int>)> {
        input.lines
            .compactMap { line -> (ClosedRange<Int>, ClosedRange<Int>)? in
                let number = Regex {
                    TryCapture {
                        OneOrMore(.digit)
                    } transform: {
                        Int($0)
                    }
                }
                let range = Regex {
                    number
                    "-"
                    number
                }
                let ranges = Regex {
                    range
                    ","
                    range
                }
                guard let values = try ranges.wholeMatch(in: line)?.output else {
                    return nil
                }
                return (values.1...values.2, values.3...values.4)
            }
            .eraseToAnyAsyncSequence()
    }
}
