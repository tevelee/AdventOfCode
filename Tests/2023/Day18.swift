@testable import AoC_2023
import Testing

private typealias CurrentPuzzle = AoC_2023_Day18
extension CurrentPuzzle: Puzzle {}

private struct Day18 {
    @Test
    func intro() throws {
        let problem = try CurrentPuzzle(#"""
        R 6 (#70c710)
        D 5 (#0dc571)
        L 2 (#5713f0)
        D 2 (#d2c081)
        R 2 (#59c680)
        D 2 (#411b91)
        L 5 (#8ceee2)
        U 2 (#caa173)
        L 1 (#1b58a2)
        U 2 (#caa171)
        R 2 (#7807d2)
        U 3 (#a77fa3)
        L 2 (#015232)
        U 2 (#7a21e3)
        """#)
        #expect(problem.solvePart1() == 62)
        #expect(problem.solvePart2() == 952_408_144_115)
    }

    @Test(.tags(.green))
    func live() throws {
        let problem = try CurrentPuzzle()
        #expect(problem.solvePart1() == 48_652)
        #expect(problem.solvePart2() == 45_757_884_535_661)
    }
}
