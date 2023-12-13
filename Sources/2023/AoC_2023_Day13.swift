import Algorithms

final class AoC_2023_Day13: Day {
    private let patterns: [Pattern]

    init(_ input: Input) throws {
        patterns = try input.wholeInput.paragraphs
            .map { $0.map(Array.init) }
            .map(Pattern.init)
    }

    func solvePart1() -> Int {
        solve(tolerance: 0)
    }

    func solvePart2() -> Int {
        solve(tolerance: 1)
    }

    private func solve(tolerance: Int) -> Int {
        patterns.sum { pattern in
            100 * numberOfLinesAboveReflection(in: pattern.rows, tolerance: tolerance) + numberOfLinesAboveReflection(in: pattern.columns, tolerance: tolerance)
        }
    }

    private func numberOfLinesAboveReflection(in pattern: [[Character]], tolerance: Int = 0) -> Int {
        pattern.indices.dropFirst().first { index in
            isEqual(lhs: pattern[..<index].reversed(), rhs: pattern[index...], tolerance: tolerance)
        } ?? 0
    }
}

private func isEqual(lhs: some Sequence<[Character]>, rhs: some Sequence<[Character]>, tolerance: Int) -> Bool {
    var numberOfErrors = 0
    for (lhs, rhs) in zip(lhs, rhs) {
        if let error = isEqual(lhs: lhs, rhs: rhs, tolerance: tolerance) {
            numberOfErrors += error
            if numberOfErrors > tolerance {
                return false
            }
        } else {
            return false
        }
    }
    return numberOfErrors == tolerance
}

private func isEqual(lhs: [Character], rhs: [Character], tolerance: Int) -> Int? {
    var numberOfErrors = 0
    for (lhs, rhs) in zip(lhs, rhs) {
        if lhs != rhs {
            numberOfErrors += 1
        }
        if numberOfErrors > tolerance {
            return nil
        }
    }
    return numberOfErrors
}

private struct Pattern {
    let characters: [[Character]]

    var rows: [[Character]] {
        characters
    }

    var columns: [[Character]] {
        (0..<characters[0].count).map { x in
            (0..<characters.count).reversed().map { y in
                characters[y][x]
            }
        }
    }
}
