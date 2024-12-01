import Utils

public final class AoC_2024_Day1 {
    private let left: [Int]
    private let right: [Int]

    public init(_ input: Input) async throws {
        (left, right) = try await input.lines.reduce(into: (left: [Int](), right: [Int]())) { result, item in
            let integers = item.integers
            result.left.append(integers[0])
            result.right.append(integers[1])
        }
    }

    public func solvePart1() async throws -> Int {
        zip(left.sorted(), right.sorted()).sum { abs($0 - $1) }
    }

    public func solvePart2() async throws -> Int {
        let frequencies = right.grouped(by: \.self).mapValues(\.count)
        return left.sum { frequencies[$0, default: 0] * $0 }
    }
}
