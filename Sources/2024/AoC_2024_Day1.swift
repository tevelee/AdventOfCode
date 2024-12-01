import Utils
import RegexBuilder

public final class AoC_2024_Day1 {
    private let left: [Int]
    private let right: [Int]

    public init(_ input: Input) async throws {
        (left, right) = try await input.lines
            .compactMap { line -> (left: Int, right: Int)? in
                guard let output = line.wholeMatch(of: /(?<left>\d+)\s+(?<right>\d+)/)?.output,
                      let left = Int(output.left),
                      let right = Int(output.right) else { return nil }
                return (left, right)
            }
            .reduce(into: (left: [], right: [])) { result, item in
                result.left.append(item.left)
                result.right.append(item.right)
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
