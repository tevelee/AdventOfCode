@testable import AoC_2023
import Testing

struct Day13 {
    @Test()
    func intro1() throws {
        let problem = try AoC_2023_Day13("""
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
        let problem = try AoC_2023_Day13()
        #expect(problem.solvePart1() == 31_265)
        #expect(problem.solvePart2() == 39_359)
    }
}
