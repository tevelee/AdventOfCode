@testable import AoC_2023
import Testing

private typealias CurrentPuzzle = AoC_2023_Day13
extension CurrentPuzzle: Puzzle {}

private struct Day13 {
    @Test()
    func intro() throws {
        let problem = try CurrentPuzzle("""
        #.##..##.
        ..#.##.#.
        ##......#
        ##......#
        ..#.##.#.
        ..##..##.
        #.#.##.#.

        #...##..#
        #....#..#
        ..##..###
        #####.##.
        #####.##.
        ..##..###
        #....#..#
        """)
        #expect(problem.solvePart1() == 405)
        #expect(problem.solvePart2() == 400)
    }

    @Test(.tags(.green))
    func live() throws {
        let problem = try CurrentPuzzle()
        #expect(problem.solvePart1() == 31_265)
        #expect(problem.solvePart2() == 39_359)
    }
}
