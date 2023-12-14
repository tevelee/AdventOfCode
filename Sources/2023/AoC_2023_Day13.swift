import Algorithms

final class AoC_2023_Day13 {
    typealias Pattern = [[Character]]
    private let patterns: [Pattern]

    init(_ input: Input) throws {
        patterns = try input.wholeInput.paragraphs.map { $0.map(Array.init) }
    }

    func solvePart1() -> Int {
        solve(forDifference: 0)
    }

    func solvePart2() -> Int {
        solve(forDifference: 1)
    }

    private func solve(forDifference difference: Int) -> Int {
        patterns.sum { pattern in
            100 * numberOfLinesAboveReflection(in: pattern, withExactDifference: difference) + numberOfLinesAboveReflection(in: pattern.rotatedClockwise(), withExactDifference: difference)
        }
    }

    private func numberOfLinesAboveReflection(in pattern: Pattern, withExactDifference difference: Int = 0) -> Int {
        pattern.indices.dropFirst().first { index in
            isEqual(lhs: pattern[..<index].reversed(), rhs: pattern[index...], withExactDifference: difference)
        } ?? 0
    }
}

private func isEqual<T: Equatable>(
    lhs: some Sequence<some Collection<T>>,
    rhs: some Sequence<some Collection<T>>,
    withExactDifference difference: Int
) -> Bool {
    var aggregateDifferences = 0
    for (lhs, rhs) in zip(lhs, rhs) {
        guard let newDifferences = numberOfDifferences(ifBelow: difference, lhs: lhs, rhs: rhs),
              aggregateDifferences + newDifferences <= difference else {
            return false
        }
        aggregateDifferences += newDifferences
    }
    return aggregateDifferences == difference

    func numberOfDifferences(
        ifBelow max: Int,
        lhs: some Collection<T>,
        rhs: some Collection<T>
    ) -> Int? {
        var numberOfDifferences = 0
        for (lhs, rhs) in zip(lhs, rhs) {
            if lhs != rhs {
                numberOfDifferences += 1
            }
            if numberOfDifferences > max {
                return nil
            }
        }
        return numberOfDifferences
    }
}
