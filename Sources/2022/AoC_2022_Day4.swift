import RegexBuilder
import Utils

public final class AoC_2022_Day4 {
    let input: Input

    public init(_ input: Input) {
        self.input = input
    }

    public func solvePart1() async throws -> Int {
        try await ranges()
            .count { range1, range2 in
                range1.contains(range2) || range2.contains(range1)
            }
    }

    public func solvePart2() async throws -> Int {
        try await ranges()
            .count { range1, range2 in
                range1.overlaps(range2)
            }
    }

    private func ranges() -> AnyAsyncSequence<(ClosedRange<Int>, ClosedRange<Int>)> {
        input.lines
            .compactMap { line -> (ClosedRange<Int>, ClosedRange<Int>)? in
                let ranges = Regex {
                    Capture(.integer)
                    "-"
                    Capture(.integer)
                    ","
                    Capture(.integer)
                    "-"
                    Capture(.integer)
                }
                guard let values = line.wholeMatch(of: ranges)?.output else {
                    return nil
                }
                return (values.1...values.2, values.3...values.4)
            }
            .eraseToAnyAsyncSequence()
    }
}
