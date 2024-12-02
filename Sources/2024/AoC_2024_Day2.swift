import Utils

public final class AoC_2024_Day2 {
    private let reports: AnyAsyncSequence<[Int]>

    public init(_ input: Input) {
        reports = input.lines.map(\.integers).eraseToAnyAsyncSequence()
    }

    public func solvePart1() async throws -> Int {
        try await reports.count(where: Self.isValidReport)
    }

    public func solvePart2() async throws -> Int {
        try await reports.count { levels in
            levels.indices.contains { index in
                Self.isValidReport(levels.removing(index))
            }
        }
    }

    private static func isValidReport(_ levels: [Int]) -> Bool {
        isValidReport(levels) { $0 - $1 }
        ||
        isValidReport(levels) { $1 - $0 }

    }

    private static func isValidReport(_ levels: [Int], differenceAlgorithm: (Int, Int) -> Int) -> Bool {
        levels.adjacentPairs().map(differenceAlgorithm).allSatisfy(isValidDifference)
    }

    private static func isValidDifference(_ diff: Int) -> Bool {
        (1...3).contains(diff)
    }
}

private extension RangeReplaceableCollection {
    func removing(_ index: Index) -> Self {
        var modified = self
        modified.remove(at: index)
        return modified
    }
}
