@testable import AoC_2023
import Testing

struct Day14 {
    @Test
    func intro1() throws {
        let problem = try AoC_2023_Day14("""
        O....#....
        O.OO#....#
        .....##...
        OO.#O....O
        .O.....O#.
        O.#..O.#.#
        ..O..#O..O
        .......O..
        #....###..
        #OO..#....
        """)
        #expect(problem.solvePart1() == 136)
        #expect(problem.solvePart2() == 64)
    }

    @Test(.tags(.green))
    func live() throws {
        let problem = try AoC_2023_Day14()
        #expect(problem.solvePart1() == 107_142)
        #expect(problem.solvePart2() == 104_815)
    }
}
