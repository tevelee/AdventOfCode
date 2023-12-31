@testable import AoC_2023
import Testing

private typealias CurrentPuzzle = AoC_2023_Day23
extension CurrentPuzzle: Puzzle {}

private struct Day23 {
    @Test
    func intro1() throws {
        let problem = try CurrentPuzzle(#"""
        #.#####################
        #.......#########...###
        #######.#########.#.###
        ###.....#.>.>.###.#.###
        ###v#####.#v#.###.#.###
        ###.>...#.#.#.....#...#
        ###v###.#.#.#########.#
        ###...#.#.#.......#...#
        #####.#.#.#######.#.###
        #.....#.#.#.......#...#
        #.#####.#.#.#########v#
        #.#...#...#...###...>.#
        #.#.#v#######v###.###v#
        #...#.>.#...>.>.#.###.#
        #####v#.#.###v#.#.###.#
        #.....#...#...#.#.#...#
        #.#########.###.#.#.###
        #...###...#...#...#.###
        ###.###.#.###v#####v###
        #...#...#.#.>.>.#.>.###
        #.###.###.#.###.#.#v###
        #.....###...###...#...#
        #####################.#
        """#)
        #expect(problem.solvePart1() == 94)
        #expect(problem.solvePart2() == 154)
    }

    @Test(.tags(.green))
    func live() throws {
        let problem = try CurrentPuzzle()
        #expect(problem.solvePart1() == 2430)
        #expect(problem.solvePart2() == 6534)
    }
}
