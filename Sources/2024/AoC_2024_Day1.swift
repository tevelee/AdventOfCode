import Utils
import RegexBuilder

public final class AoC_2024_Day1 {
    private let left: [Int]
    private let right: [Int]

    public init(_ input: Input) async throws {
        let number = TryCapture {
            OneOrMore(CharacterClass.digit)
        } transform: {
            Int($0)
        }
        let regex = Regex {
            number
            OneOrMore(CharacterClass.whitespace)
            number
        }
        (left, right) = try await input.lines.collect()
            .compactMap { $0.wholeMatch(of: regex)?.output as (_, left: Int, right: Int)? }
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
