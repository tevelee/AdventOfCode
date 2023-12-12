@testable import AoC_2023
import Testing

struct Day11 {
    @Test
    func intro1() throws {
        let problem = try AoC_2023_Day11("""
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
        let problem = try AoC_2023_Day11()
        #expect(problem.solve(expansionSize: 2) == 9_522_407)
        #expect(problem.solve(expansionSize: 1_000_000) == 544_723_432_977)
    }
}
