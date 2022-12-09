import Algorithms
import Utils

public final class AoC_2021_Day8 {
    let lines: Lines

    public init(_ inputFileURL: URL) {
        lines = inputFileURL.lines.eraseToAnyAsyncSequence()
    }

    public init(_ input: String) {
        lines = input.lines.async.eraseToAnyAsyncSequence()
    }

    public func solvePart1() async throws -> Int {
        try await lines.map { line in
            let segments = line.replacingOccurrences(of: "\n", with: "").split(separator: "|")
            let outputValues = segments[1].words
            return outputValues.map(\.count).filter([2,3,4,7].contains).count
        }
        .reduce(0, +)
    }

    public func solvePart2() async throws -> Int {
        try await lines.map { line -> String in
            let segments = line.replacingOccurrences(of: "\n", with: "").split(separator: "|")
            let clues = segments[0].words.sorted { $0.count < $1.count }.map(Set.init)
            let outputValues = segments[1].words
            let mapping = self.mapping(for: clues)
            let numbers = outputValues
                .compactMap { character in character.compactMap { mapping[$0] } }
                .compactMap { digit in self.digits[Set(digit)] }
            return String(numbers)
        }
        .compactMap { Int($0) }
        .reduce(0, +)
    }

    private let digits: [Set<Character>: Character] = [
        Set("abcefg"): "0",
        Set("cf"): "1",
        Set("acdeg"): "2",
        Set("acdfg"): "3",
        Set("bcdf"): "4",
        Set("abdfg"): "5",
        Set("abdefg"): "6",
        Set("acf"): "7",
        Set("abcdefg"): "8",
        Set("abcdfg"): "9"
    ]

    private func mapping(for clues: [Set<Character>]) -> [Character: Character] {
        var segments: [Character: Character] = [:]
        let one = clues[0]
        let seven = clues[1]
        let four = clues[2]
        let eight = clues[9]
        segments["a"] = seven.subtracting(one).first!
        let nine = clues.first { $0.count == 6 && four.subtracting($0).isEmpty }!
        segments["e"] = eight.subtracting(nine).first!
        let three = clues.first { $0.count == 5 && one.subtracting($0).isEmpty }!
        segments["b"] = four.subtracting(three).first!
        segments["g"] = nine.subtracting(four).first { $0 != segments["a"] }!
        segments["d"] = eight.subtracting(one).subtracting(segments.values).first!
        let five = clues.first { $0.count == 5 && $0.contains(segments["b"]!) && !$0.contains(segments["e"]!) }!
        segments["c"] = one.subtracting(five).first!
        segments["f"] = one.first { $0 != segments["c"] }!
        return segments.flipped
    }
}

extension Dictionary where Value: Hashable {
    var flipped: [Value: Key] {
        Dictionary<Value, [Key]>(grouping: keys, by: { self[$0]! }).compactMapValues(\.first)
    }
}
