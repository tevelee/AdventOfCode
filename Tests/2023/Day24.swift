@testable import AoC_2023
import Testing

private typealias CurrentPuzzle = AoC_2023_Day24
extension CurrentPuzzle: Puzzle {}

private struct Day24 {
    @Test
    func intro1() throws {
        let problem = try CurrentPuzzle(#"""
        19, 13, 30 @ -2,  1, -2
        18, 19, 22 @ -1, -1, -2
        20, 25, 34 @ -2, -2, -4
        12, 31, 28 @ -1, -2, -1
        20, 19, 15 @  1, -5, -3
        """#)
        #expect(problem.solvePart1(7...29) == 2)
        #expect(problem.solvePart2() == 24 + 13 + 10)
    }

    @Test(.tags(.green))
    func live() throws {
        let problem = try CurrentPuzzle()
        let range = (2...4).map { Double($0 * 1e14) }
        #expect(problem.solvePart1(range) == 18_184)
        #expect(problem.solvePart2() == 149_412_455_352_770 + 174_964_385_672_289 + 233_413_147_425_100)
    }
}

private extension ClosedRange {
    func map<T>(_ transform: (Bound) -> T) -> ClosedRange<T> {
        .init(uncheckedBounds: (lower: transform(lowerBound), upper: transform(upperBound)))
    }
}
