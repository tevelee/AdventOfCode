@testable import AoC_2023
import Testing

private typealias CurrentPuzzle = AoC_2023_Day11
extension CurrentPuzzle: Puzzle {}

private struct Day11 {
    @Test
    func intro() throws {
        let problem = try CurrentPuzzle("""
        ...#......
        .......#..
        #.........
        ..........
        ......#...
        .#........
        .........#
        ..........
        .......#..
        #...#.....
        """)
        #expect(problem.solve(expansionSize: 2) == 374)
        #expect(problem.solve(expansionSize: 10) == 1030)
        #expect(problem.solve(expansionSize: 100) == 8410)
    }

    @Test(.tags(.green))
    func live() throws {
        let problem = try CurrentPuzzle()
        #expect(problem.solve(expansionSize: 2) == 9_522_407)
        #expect(problem.solve(expansionSize: 1_000_000) == 544_723_432_977)
    }
}
