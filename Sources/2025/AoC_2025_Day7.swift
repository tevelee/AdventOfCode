import Utils

public final class AoC_2025_Day7 {
    private let start: Int
    private let splittersPerLines: [Set<Int>]

    public init(_ input: Input) throws {
        let lines = try input.wholeInput.lines.map(Array.init)
        guard let start = lines.first?.firstIndex(of: "S") else { throw ParseError() }
        self.start = start
        self.splittersPerLines = lines.dropFirst().map { line in
            Set(line.enumerated().filter { $0.element == "^" }.map(\.offset))
        }
    }

    public func solvePart1() -> Int {
        var beams: Set<Int> = [start]
        var numberOfSplits = 0
        for splitters in splittersPerLines {
            let splits = beams.intersection(splitters)
            numberOfSplits += splits.count
            beams = beams.subtracting(splitters).union(splits.flatMap { [$0 - 1, $0 + 1] })
        }
        return numberOfSplits
    }

    public func solvePart2() -> Int {
        var timelines: [Int: Int] = [start: 1]
        for splitters in splittersPerLines {
            let beams = Set(timelines.keys)
            let splits = beams.intersection(splitters)
            for split in splits {
                let value = timelines[split]!
                timelines[split] = nil
                timelines[split - 1, default: 0] += value
                timelines[split + 1, default: 0] += value
            }
        }
        return timelines.values.sum()
    }
}
