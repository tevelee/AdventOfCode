import Utils
import RegexBuilder

public final class AoC_2024_Day1 {
    private let left: [Int]
    private let right: [Int]

    public init(_ input: Input) async throws {
        (left, right) = try await input.lines.reduce(into: (left: [], right: [])) { result, item in
            let (left, right) = try item.integers.elements()
            result.left.append(left)
            result.right.append(right)
        }
    }

    public func solvePart1() -> Int {
        zip(left.sorted(), right.sorted()).sum { abs($0 - $1) }
    }

    public func solvePart2() -> Int {
        let frequencies = right.grouped(by: \.self).mapValues(\.count)
        return left.sum { frequencies[$0, default: 0] * $0 }
    }
}
