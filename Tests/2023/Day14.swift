@testable import AoC_2023
import Testing

private typealias CurrentPuzzle = AoC_2023_Day14
extension CurrentPuzzle: Puzzle {}

private struct Day14 {
    @Test
    func intro() throws {
        let problem = try CurrentPuzzle("""
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
        let problem = try CurrentPuzzle()
        #expect(problem.solvePart1() == 107_142)
        #expect(problem.solvePart2() == 104_815)
    }
}
