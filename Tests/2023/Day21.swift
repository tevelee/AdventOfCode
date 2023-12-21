@testable import AoC_2023
import Testing

private typealias CurrentPuzzle = AoC_2023_Day21
extension CurrentPuzzle: Puzzle {}

@Suite(.tags("debug"))
private struct Day21 {
    @Test
    func intro1() throws {
        let problem = try CurrentPuzzle(#"""
        ...........
        .....###.#.
        .###.##..#.
        ..#.#...#..
        ....#.#....
        .##..S####.
        .##..#...#.
        .......##..
        .##.#.####.
        .##..##.##.
        ...........
        """#)
        #expect(problem.solvePart1(steps: 6) == 16)
        #expect(problem.solvePart2(steps: 6) == 16)
        #expect(problem.solvePart2(steps: 10) == 50)
        #expect(problem.solvePart2(steps: 50) == 1594)
        #expect(problem.solvePart2(steps: 100) == 6536)
        #expect(problem.solvePart2(steps: 500) == 167004)
        #expect(problem.solvePart2(steps: 1000) == 668697)
        #expect(problem.solvePart2(steps: 5000) == 16733044)
    }

    @Test(.tags(.green))
    func live() throws {
        let problem = try CurrentPuzzle()
        #expect(problem.solvePart1(steps: 64) == 3605)
        #expect(problem.solvePart2(steps: 26_501_365) == 0)
    }
}
