@testable import AoC_2023
import Testing

private typealias CurrentPuzzle = AoC_2023_Day3
extension CurrentPuzzle: Puzzle {}

private struct Day3 {
    @Test
    func intro() throws {
        let problem = try CurrentPuzzle("""
        467..114..
        ...*......
        ..35..633.
        ......#...
        617*......
        .....+.58.
        ..592.....
        ......755.
        ...$.*....
        .664.598..
        """)
        #expect(problem.solvePart1() == 4361)
        #expect(problem.solvePart2() == 467_835)
    }

    @Test(.tags(.green))
    func live() throws {
        let problem = try CurrentPuzzle()
        #expect(problem.solvePart1() == 507_214)
        #expect(problem.solvePart2() == 72_553_319)
    }
}
